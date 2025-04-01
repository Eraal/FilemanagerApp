from flask import Flask, render_template, request, send_from_directory, redirect, url_for, flash, jsonify
import os
from models import db, Folder, User, File
from flask_login import LoginManager, login_user, login_required, logout_user, current_user




app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:admin@localhost/file_manager'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'Rald'


# Initialize Flask-Login
login_manager = LoginManager(app)
login_manager.login_view = 'login'

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


db.init_app(app)

with app.app_context():
    db.create_all()

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
    folders = Folder.query.all()  # Fetch folders from the database
    return render_template('myfile.html', folders=folders)

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
    # Fetch the folder and its files from the database
    folder = Folder.query.get(folder_id)
    if not folder:
        return jsonify({'error': 'Folder not found'}), 404
    
    
    # Fetch files associated with the folder
    files = File.query.filter_by(folder_id=folder_id).all()

    # Prepare the response
    files_data = [{
        'id': file.id,
        'name': file.name,
        'file_path': file.file_path,
        'file_size': file.file_size,
        'mime_type': file.mime_type,
        'uploaded_at': file.uploaded_at.isoformat()
    } for file in files]

    

    return jsonify({
        'folder_id': folder.id,
        'folder_name': folder.name,
        'files': files_data
    })

    





if __name__ == '__main__':
    app.run(debug=True)
