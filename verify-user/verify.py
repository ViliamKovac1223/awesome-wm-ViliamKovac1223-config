#!/usr/bin/python3

import hashlib
import getopt
import sys
import os
from tkinter import *
import tkinter.messagebox

DEFAULT_PASSWORD = "toor"
HOME = os.popen("echo $HOME").read().rstrip() # constat of home folder
PASSWORD_FILE = HOME + '/.config/awesome/verify-user/password'

MAIN_COLOR = "#444"
SECOND_COLOR = "#797979"
TEXT_COLOR = "#E0E0E0"
TITLE = "Verify user"


def main(argv):
    title = TITLE # set default title

    # check arguments
    is_command_available = False
    try:
        opts, args = getopt.getopt(argv,"ht:sc:")
    except getopt.GetoptError:
        help()
        sys.exit(2)

    for opt, arg in opts:
        if opt == "-h": # help option
            help()
            sys.exit()
        elif opt == "-s": # set option
            set_password()
            sys.exit()
        elif opt == "-c": # command flag
            command = arg
            is_command_available = True
        elif opt == "-t": # title flag
            title = arg
    
    if (not is_command_available):
        help()
        sys.exit(3)
    
    # default event
    check_password(command, title)

def check_password(command, title):
    root = Tk()
    root.title(title)
    root.geometry('400x200')
    root.eval('tk::PlaceWindow . center')

    label = Label(root, text ="Verify your password user:")
    label.pack(pady=20)

    password_input = Entry(root, show="*", width=15)
    password_input.pack(pady=20)
    password_input.focus_set()
    
    verify_button = Button(root, bd = None, text ="verify", command = lambda: verify(password_input, command)) # on button click verify password
    verify_button.pack(pady=20)
    
    root.bind('<Return>', lambda x: verify(password_input, command)) # on Enter press verify password
    root.bind('<Escape>', lambda x: root.destroy()) # on Enter press verify password

    # styling 
    root.configure(background = MAIN_COLOR)
    label.configure(background = MAIN_COLOR, fg = TEXT_COLOR)
    password_input.configure(background = SECOND_COLOR)
    verify_button.configure(background = SECOND_COLOR, fg = TEXT_COLOR)

    root.mainloop()
    
def set_password():
    root = Tk()
    root.title('Set password')
    root.geometry('400x220')
    root.eval('tk::PlaceWindow . center')

    label = Label(root, text ="Set a new password:")
    label.pack(pady=20)
    
    password_input = Entry(root, show="*", width=15)
    password_input.pack()
    password_input.focus_set()

    label1 = Label(root, text ="Repeat a new password:")
    label1.pack(pady=20)
    
    password_input1 = Entry(root, show="*", width=15)
    password_input1.pack()
    
    set_button = Button(root, bd = None, text ="verify", command = lambda: check_new_password(password_input.get(), password_input1.get())) # on button click set password
    set_button.pack(pady=20)
    
    root.bind('<Return>', lambda x: check_new_password(password_input.get(), password_input1.get())) # on Enter press set password

    # styling 
    root.configure(background = MAIN_COLOR)
    label.configure(background = MAIN_COLOR, fg = TEXT_COLOR)
    label1.configure(background = MAIN_COLOR, fg = TEXT_COLOR)
    password_input.configure(background = SECOND_COLOR)
    password_input1.configure(background = SECOND_COLOR)
    set_button.configure(background = SECOND_COLOR, fg = TEXT_COLOR)

    root.mainloop()
    
def check_new_password(password, password1):
    if (password == ""):
        tkinter.messagebox.showinfo('Warning','Passwords are not filled')
    elif (password == password1):
        write_new_password(password)
        sys.exit()
    else:
        tkinter.messagebox.showinfo('Warning','Passwords are not the same')

def write_new_password(password):
    f = open(PASSWORD_FILE, "w")
    f.write(hash_password(password))
    f.close()


def help():
    print("-s # set a new password")
    print("-c <command> # set a command that will be executed if password is right")
    print("-t <title> # set a title for a window")

def hash_password(password):
    return hashlib.md5(password.encode()).hexdigest()

def verify(password_input, command):
    password = password_input.get()

    password_hash = hash_password(password)
    original_password_hash = get_password()
    if (password_hash == original_password_hash):
        os.system(command)
        sys.exit()
    else:
        password_input.delete(0, END)
        tkinter.messagebox.showinfo('Warning','Wrong password')

def get_password():
    if(os.path.isfile(PASSWORD_FILE)):
        f = open(PASSWORD_FILE, "r")
        password = f.readline()
        f.close()
    else:
        password = hash_password(DEFAULT_PASSWORD)

    return password

if __name__ == '__main__':
    main(sys.argv[1:])
