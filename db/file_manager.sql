PGDMP                      }            file_manager    17.2    17.2 J               0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false                       1262    74028    file_manager    DATABASE     �   CREATE DATABASE file_manager WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE file_manager;
                     postgres    false            �            1259    74062    file    TABLE     =  CREATE TABLE public.file (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    file_path text NOT NULL,
    file_size bigint NOT NULL,
    mime_type character varying(50) NOT NULL,
    folder_id integer,
    user_id integer,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.file;
       public         heap r       postgres    false            �            1259    74143    file_access    TABLE     �   CREATE TABLE public.file_access (
    id integer NOT NULL,
    file_id integer NOT NULL,
    user_id integer NOT NULL,
    permission character varying(10) NOT NULL,
    granted_at timestamp without time zone
);
    DROP TABLE public.file_access;
       public         heap r       postgres    false            �            1259    74142    file_access_id_seq    SEQUENCE     �   CREATE SEQUENCE public.file_access_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.file_access_id_seq;
       public               postgres    false    232                       0    0    file_access_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.file_access_id_seq OWNED BY public.file_access.id;
          public               postgres    false    231            �            1259    74061    file_id_seq    SEQUENCE     �   CREATE SEQUENCE public.file_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.file_id_seq;
       public               postgres    false    222                       0    0    file_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.file_id_seq OWNED BY public.file.id;
          public               postgres    false    221            �            1259    74129    file_version    TABLE     �   CREATE TABLE public.file_version (
    id integer NOT NULL,
    file_id integer NOT NULL,
    version_number integer NOT NULL,
    file_path text NOT NULL,
    created_at timestamp without time zone
);
     DROP TABLE public.file_version;
       public         heap r       postgres    false            �            1259    74128    file_version_id_seq    SEQUENCE     �   CREATE SEQUENCE public.file_version_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.file_version_id_seq;
       public               postgres    false    230                       0    0    file_version_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.file_version_id_seq OWNED BY public.file_version.id;
          public               postgres    false    229            �            1259    74097 
   fileaccess    TABLE     �  CREATE TABLE public.fileaccess (
    id integer NOT NULL,
    file_id integer,
    user_id integer,
    permission character varying(10),
    granted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fileaccess_permission_check CHECK (((permission)::text = ANY ((ARRAY['read'::character varying, 'write'::character varying, 'delete'::character varying])::text[])))
);
    DROP TABLE public.fileaccess;
       public         heap r       postgres    false            �            1259    74096    fileaccess_id_seq    SEQUENCE     �   CREATE SEQUENCE public.fileaccess_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.fileaccess_id_seq;
       public               postgres    false    226                       0    0    fileaccess_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.fileaccess_id_seq OWNED BY public.fileaccess.id;
          public               postgres    false    225            �            1259    74082    fileversion    TABLE     �   CREATE TABLE public.fileversion (
    id integer NOT NULL,
    file_id integer,
    version_number integer NOT NULL,
    file_path text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.fileversion;
       public         heap r       postgres    false            �            1259    74081    fileversion_id_seq    SEQUENCE     �   CREATE SEQUENCE public.fileversion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.fileversion_id_seq;
       public               postgres    false    224                       0    0    fileversion_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.fileversion_id_seq OWNED BY public.fileversion.id;
          public               postgres    false    223            �            1259    74044    folder    TABLE     �   CREATE TABLE public.folder (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent_folder_id integer,
    user_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.folder;
       public         heap r       postgres    false            �            1259    74043    folder_id_seq    SEQUENCE     �   CREATE SEQUENCE public.folder_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.folder_id_seq;
       public               postgres    false    220                        0    0    folder_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.folder_id_seq OWNED BY public.folder.id;
          public               postgres    false    219            �            1259    74116    user    TABLE     �   CREATE TABLE public."user" (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    created_at timestamp without time zone
);
    DROP TABLE public."user";
       public         heap r       postgres    false            �            1259    74115    user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.user_id_seq;
       public               postgres    false    228            !           0    0    user_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;
          public               postgres    false    227            �            1259    74030    users    TABLE     �   CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.users;
       public         heap r       postgres    false            �            1259    74029    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public               postgres    false    218            "           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public               postgres    false    217            H           2604    74065    file id    DEFAULT     b   ALTER TABLE ONLY public.file ALTER COLUMN id SET DEFAULT nextval('public.file_id_seq'::regclass);
 6   ALTER TABLE public.file ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    221    222    222            P           2604    74146    file_access id    DEFAULT     p   ALTER TABLE ONLY public.file_access ALTER COLUMN id SET DEFAULT nextval('public.file_access_id_seq'::regclass);
 =   ALTER TABLE public.file_access ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    232    231    232            O           2604    74132    file_version id    DEFAULT     r   ALTER TABLE ONLY public.file_version ALTER COLUMN id SET DEFAULT nextval('public.file_version_id_seq'::regclass);
 >   ALTER TABLE public.file_version ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    230    229    230            L           2604    74100    fileaccess id    DEFAULT     n   ALTER TABLE ONLY public.fileaccess ALTER COLUMN id SET DEFAULT nextval('public.fileaccess_id_seq'::regclass);
 <   ALTER TABLE public.fileaccess ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    225    226    226            J           2604    74085    fileversion id    DEFAULT     p   ALTER TABLE ONLY public.fileversion ALTER COLUMN id SET DEFAULT nextval('public.fileversion_id_seq'::regclass);
 =   ALTER TABLE public.fileversion ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    223    224    224            F           2604    74047 	   folder id    DEFAULT     f   ALTER TABLE ONLY public.folder ALTER COLUMN id SET DEFAULT nextval('public.folder_id_seq'::regclass);
 8   ALTER TABLE public.folder ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    220    219    220            N           2604    74119    user id    DEFAULT     d   ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);
 8   ALTER TABLE public."user" ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    227    228    228            D           2604    74033    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    218    217    218            
          0    74062    file 
   TABLE DATA           j   COPY public.file (id, name, file_path, file_size, mime_type, folder_id, user_id, uploaded_at) FROM stdin;
    public               postgres    false    222   &X                 0    74143    file_access 
   TABLE DATA           S   COPY public.file_access (id, file_id, user_id, permission, granted_at) FROM stdin;
    public               postgres    false    232   CX                 0    74129    file_version 
   TABLE DATA           Z   COPY public.file_version (id, file_id, version_number, file_path, created_at) FROM stdin;
    public               postgres    false    230   `X                 0    74097 
   fileaccess 
   TABLE DATA           R   COPY public.fileaccess (id, file_id, user_id, permission, granted_at) FROM stdin;
    public               postgres    false    226   }X                 0    74082    fileversion 
   TABLE DATA           Y   COPY public.fileversion (id, file_id, version_number, file_path, created_at) FROM stdin;
    public               postgres    false    224   �X                 0    74044    folder 
   TABLE DATA           Q   COPY public.folder (id, name, parent_folder_id, user_id, created_at) FROM stdin;
    public               postgres    false    220   �X                 0    74116    user 
   TABLE DATA           P   COPY public."user" (id, username, email, password_hash, created_at) FROM stdin;
    public               postgres    false    228   YY                 0    74030    users 
   TABLE DATA           O   COPY public.users (id, username, email, password_hash, created_at) FROM stdin;
    public               postgres    false    218   'Z       #           0    0    file_access_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.file_access_id_seq', 1, false);
          public               postgres    false    231            $           0    0    file_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.file_id_seq', 1, false);
          public               postgres    false    221            %           0    0    file_version_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.file_version_id_seq', 1, false);
          public               postgres    false    229            &           0    0    fileaccess_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.fileaccess_id_seq', 1, false);
          public               postgres    false    225            '           0    0    fileversion_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.fileversion_id_seq', 1, false);
          public               postgres    false    223            (           0    0    folder_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.folder_id_seq', 10, true);
          public               postgres    false    219            )           0    0    user_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.user_id_seq', 1, true);
          public               postgres    false    227            *           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 1, true);
          public               postgres    false    217            i           2606    74148    file_access file_access_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.file_access
    ADD CONSTRAINT file_access_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.file_access DROP CONSTRAINT file_access_pkey;
       public                 postgres    false    232            [           2606    74070    file file_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.file
    ADD CONSTRAINT file_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.file DROP CONSTRAINT file_pkey;
       public                 postgres    false    222            g           2606    74136    file_version file_version_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.file_version
    ADD CONSTRAINT file_version_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.file_version DROP CONSTRAINT file_version_pkey;
       public                 postgres    false    230            _           2606    74104    fileaccess fileaccess_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.fileaccess
    ADD CONSTRAINT fileaccess_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.fileaccess DROP CONSTRAINT fileaccess_pkey;
       public                 postgres    false    226            ]           2606    74090    fileversion fileversion_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.fileversion
    ADD CONSTRAINT fileversion_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.fileversion DROP CONSTRAINT fileversion_pkey;
       public                 postgres    false    224            Y           2606    74050    folder folder_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.folder
    ADD CONSTRAINT folder_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.folder DROP CONSTRAINT folder_pkey;
       public                 postgres    false    220            a           2606    74127    user user_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public."user" DROP CONSTRAINT user_email_key;
       public                 postgres    false    228            c           2606    74123    user user_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public."user" DROP CONSTRAINT user_pkey;
       public                 postgres    false    228            e           2606    74125    user user_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public."user" DROP CONSTRAINT user_username_key;
       public                 postgres    false    228            S           2606    74042    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public                 postgres    false    218            U           2606    74038    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public                 postgres    false    218            W           2606    74040    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public                 postgres    false    218            r           2606    74149 $   file_access file_access_file_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.file_access
    ADD CONSTRAINT file_access_file_id_fkey FOREIGN KEY (file_id) REFERENCES public.file(id);
 N   ALTER TABLE ONLY public.file_access DROP CONSTRAINT file_access_file_id_fkey;
       public               postgres    false    232    222    4699            s           2606    74154 $   file_access file_access_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.file_access
    ADD CONSTRAINT file_access_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);
 N   ALTER TABLE ONLY public.file_access DROP CONSTRAINT file_access_user_id_fkey;
       public               postgres    false    232    228    4707            l           2606    74071    file file_folder_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.file
    ADD CONSTRAINT file_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES public.folder(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.file DROP CONSTRAINT file_folder_id_fkey;
       public               postgres    false    220    4697    222            m           2606    74076    file file_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.file
    ADD CONSTRAINT file_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.file DROP CONSTRAINT file_user_id_fkey;
       public               postgres    false    222    4693    218            q           2606    74137 &   file_version file_version_file_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.file_version
    ADD CONSTRAINT file_version_file_id_fkey FOREIGN KEY (file_id) REFERENCES public.file(id);
 P   ALTER TABLE ONLY public.file_version DROP CONSTRAINT file_version_file_id_fkey;
       public               postgres    false    230    222    4699            o           2606    74105 "   fileaccess fileaccess_file_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.fileaccess
    ADD CONSTRAINT fileaccess_file_id_fkey FOREIGN KEY (file_id) REFERENCES public.file(id) ON DELETE CASCADE;
 L   ALTER TABLE ONLY public.fileaccess DROP CONSTRAINT fileaccess_file_id_fkey;
       public               postgres    false    222    4699    226            p           2606    74110 "   fileaccess fileaccess_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.fileaccess
    ADD CONSTRAINT fileaccess_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 L   ALTER TABLE ONLY public.fileaccess DROP CONSTRAINT fileaccess_user_id_fkey;
       public               postgres    false    218    226    4693            n           2606    74091 $   fileversion fileversion_file_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.fileversion
    ADD CONSTRAINT fileversion_file_id_fkey FOREIGN KEY (file_id) REFERENCES public.file(id) ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.fileversion DROP CONSTRAINT fileversion_file_id_fkey;
       public               postgres    false    222    224    4699            j           2606    74051 #   folder folder_parent_folder_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.folder
    ADD CONSTRAINT folder_parent_folder_id_fkey FOREIGN KEY (parent_folder_id) REFERENCES public.folder(id) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.folder DROP CONSTRAINT folder_parent_folder_id_fkey;
       public               postgres    false    220    4697    220            k           2606    74056    folder folder_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.folder
    ADD CONSTRAINT folder_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.folder DROP CONSTRAINT folder_user_id_fkey;
       public               postgres    false    218    220    4693            
      x������ � �            x������ � �            x������ � �            x������ � �            x������ � �         �   x�uͱ�0����)|�^{�k���qrb1@"����/�u���m���l+�W p�Ic}���rf�DFU]dp{����.��=���,��+T2�,j�'V�ݾ�C�o���	��8�އKY�Q�B�d�=_���-����� �n/6h         �   x���n1@绯���ɱ/N��,+�c��NDu��P����'���K��Ԫ���Mu��������o�����0q.��Ͳ�~�n_���~�7�%hMP)G�*Y��b3uM�@ģ QFPJb����ـ0�hI���F�ɲρ�n��VE�Z�CFsaH�6T610n��H/0��%���2~O�8��:@�         �   x���N1�뻧�H��z��]AE$$�h�^;
�\���S͏>͸馫M��/��^u3��=�zZ�z9O���s�gB	1��v�����z?����jϻ^����@��
;Q/\}I͵QCe��Sh海�]A4+6���BdȽ�J&�*TvaXD����&D��R�	��#=���g�%$
���2��T�?)     