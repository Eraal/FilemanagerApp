from flask import Flask, render_template, request, send_from_directory, redirect, url_for, flash, jsonify
import os
from models import db, Folder, User, File
from flask_login import LoginManager, login_user, login_required, logout_user, current_user
from werkzeug.utils import secure_filename
import mimetypes



app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:admin@localhost/file_manager'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'Rald'


# Add allowed extensions
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'pdf', 'doc', 'docx', 'txt'}

# Initialize Flask-Login
login_manager = LoginManager(app)
login_manager.login_view = 'login'

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


db.init_app(app)

with app.app_context():
    db.create_all()
############################################ FILES ###################################################
def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/myfiles-refresh')
@login_required
def myfiles_refresh():
    folders = db.session.query(
        Folder,
        db.func.count(File.id).label('file_count')
    ).outerjoin(
        File, Folder.id == File.folder_id
    ).group_by(
        Folder.id
    ).all()
    
    folders_with_counts = []
    for folder, count in folders:
        folder.file_count = count
        folders_with_counts.append(folder)
    
    return render_template('_folder_list.html', folders=folders_with_counts)



@app.route('/upload-file', methods=['POST'])
@login_required
def upload_file():
    if 'file' not in request.files:
        return jsonify({'message': 'No file part'}), 400
        
    file = request.files['file']
    folder_id = request.form.get('folder_id')
    
    if file.filename == '':
        return jsonify({'message': 'No selected file'}), 400
        
    if not folder_id:
        return jsonify({'message': 'No folder specified'}), 400
        
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)
        
        # Get file size
        file_size = os.path.getsize(filepath)
        
        # Get MIME type
        mime_type = file.mimetype
        
        # Create file record
        new_file = File(
            name=filename,
            file_path=filepath,
            file_size=file_size,
            mime_type=mime_type,
            folder_id=folder_id,
            user_id=current_user.id
        )
        db.session.add(new_file)
        db.session.commit()

        # Return the updated folder information
        folder = Folder.query.get(folder_id)
        return jsonify({
            'message': 'File uploaded successfully',
            'folder': {
                'id': folder.id,
                'name': folder.name,
                'file_count': File.query.filter_by(folder_id=folder.id).count()
            }
        })
    
    return jsonify({'message': 'File type not allowed'}), 400

# Get all folders for move options
@app.route('/api/folders')
@login_required
def get_folders():
    folders = Folder.query.filter_by(user_id=current_user.id).all()
    folders_data = []
    for folder in folders:
        folders_data.append({
            'id': folder.id,
            'name': folder.name,
            'file_count': File.query.filter_by(folder_id=folder.id).count(),
            'created_at': folder.created_at.isoformat()
        })
    return jsonify(folders_data)

# Rename file
@app.route('/rename-file/<int:file_id>', methods=['POST'])
@login_required
def rename_file(file_id):
    data = request.get_json()
    file = File.query.get(file_id)
    pass

# Move file
@app.route('/move-file/<int:file_id>', methods=['POST'])
@login_required
def move_file(file_id):
    data = request.get_json()
    pass

# Delete file
@app.route('/delete-file/<int:file_id>', methods=['DELETE'])
@login_required
def delete_file(file_id):
    pass


  ########################  # Routes for registration, login, and logout ################################################################
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username')
        email = request.form.get('email')
        password = request.form.get('password')

        print(f"Username: {username}, Email: {email}, Password: {password}")

        if User.query.filter_by(username=username).first():
            flash('Username already exists!', 'error')
            return redirect(url_for('register'))

        if User.query.filter_by(email=email).first():
            flash('Email already exists!', 'error')
            return redirect(url_for('register'))

        new_user = User(username=username, email=email)
        new_user.set_password(password)
        db.session.add(new_user)
        db.session.commit()
        

        flash('Registration successful! Please log in.', 'success')
        return redirect(url_for('login'))

    return render_template('register.html')

#################################################### LOGIN ####################################################

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        user = User.query.filter_by(username=username).first()

        if user and user.check_password(password):
            login_user(user)
            flash('Logged in successfully!', 'success')
            return redirect(url_for('myfiles'))  # Redirect to the main page
        else:
            flash('Invalid username or password!', 'error')

    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('Logged out successfully!', 'success')
    return redirect(url_for('login'))

UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


#################################### INTRO ################################################
@app.route('/')
def index():
    return render_template('intro.html')

############################################################ myfiles.html ######################################
@app.route('/myfiles')
@login_required
def myfiles():
    # Fetch folders with their file counts
    folders = db.session.query(
        Folder,
        db.func.count(File.id).label('file_count')
    ).outerjoin(
        File, Folder.id == File.folder_id
    ).group_by(
        Folder.id
    ).all()
    
    # Convert to list of folder objects with file_count attribute
    folders_with_counts = []
    for folder, count in folders:
        folder.file_count = count
        folders_with_counts.append(folder)
    
    return render_template('myfile.html', folders=folders_with_counts)

@app.route('/create-folder', methods=['POST'])
def create_folder():
    data = request.json
    folder_name = data.get('folder_name')

    if not folder_name:
        return jsonify({'message': 'Folder name is required'}), 400

    existing_folder = Folder.query.filter_by(name=folder_name).first()
    if existing_folder:
        return jsonify({'message': 'Folder already exists'}), 400

    try:
        new_folder = Folder(name=folder_name, user_id=1)  # Replace 1 with actual user_id
        db.session.add(new_folder)
        db.session.commit()
        return jsonify({'message': f'Folder "{folder_name}" created successfully!'}), 201
    except Exception as e:
        db.session.rollback()
        print(f"Error creating folder: {e}")  # Log the error
        return jsonify({'message': 'Error creating folder', 'error': str(e)}), 500

############################################################### FOLDER FILE CONTAINER #############################################

@app.route('/folder_files/<int:folder_id>')
@login_required
def folder_files(folder_id):
    # Fetch the folder from the database
    folder = Folder.query.get(folder_id)
    if not folder:
        flash('Folder not found!', 'error')
        return redirect(url_for('myfiles'))

    # Render the folder_files.html template with the folder ID
    return render_template('folder_files.html', folder_id=folder_id)

@app.route('/api/folders/<int:folder_id>/files', methods=['GET'])
@login_required
def get_folder_files(folder_id):
    # Fetch files in this folder
    files = File.query.filter_by(folder_id=folder_id).all()
    
    # Prepare response
    files_data = [{
        'id': file.id,
        'name': file.name,
        'file_path': file.file_path,
        'file_size': file.file_size,
        'mime_type': file.mime_type,
        'uploaded_at': file.uploaded_at.isoformat()
    } for file in files]

    return jsonify({
        'folder_id': folder_id,
        'folder_name': Folder.query.get(folder_id).name,
        'files': files_data
    })

@app.route('/rename-folder/<int:folder_id>', methods=['POST'])
@login_required
def rename_folder(folder_id):
    data = request.get_json()
    new_name = data.get('new_name')
    
    if not new_name:
        return jsonify({'message': 'New name is required'}), 400
    
    folder = Folder.query.get(folder_id)
    if not folder:
        return jsonify({'message': 'Folder not found'}), 404
    
    if folder.user_id != current_user.id:
        return jsonify({'message': 'Unauthorized'}), 403
    
    try:
        folder.name = new_name
        db.session.commit()
        return jsonify({'message': 'Folder renamed successfully'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'message': 'Error renaming folder', 'error': str(e)}), 500


@app.route('/delete-folder/<int:folder_id>', methods=['DELETE'])
@login_required
def delete_folder(folder_id):
    folder = Folder.query.get(folder_id)
    if not folder:
        return jsonify({'message': 'Folder not found'}), 404
    
    if folder.user_id != current_user.id:
        return jsonify({'message': 'Unauthorized'}), 403
    
    try:
        # First delete all files in the folder
        File.query.filter_by(folder_id=folder_id).delete()
        
        # Then delete the folder
        db.session.delete(folder)
        db.session.commit()
        return jsonify({'message': 'Folder deleted successfully'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'message': 'Error deleting folder', 'error': str(e)}), 500

    
###############################################################           ###############################################

@app.route('/cloud')
@login_required
def cloud():
    return render_template('cloud.html')


if __name__ == '__main__':
    app.run(debug=True)
