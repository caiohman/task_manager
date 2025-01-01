import shlex,subprocess, sys, time


# for now in order to run follow this steps:

# debug
# sudo su
# source repo/task_manager/scripts/launcher/venv/bin/activate
# python repo/task_manager/scripts/launcher/task_manager_launcher.py --base
# exit
# source repo/task_manager/scripts/launcher/venv/bin/activate
# python repo/task_manager/scripts/launcher/task_manager_launcher.py --debug

# container
# sudo su
# source repo/task_manager/scripts/launcher/venv/bin/activate
# python repo/task_manager/scripts/launcher/task_manager_launcher.py --container
# exit
# python repo/task_manager/scripts/launcher/task_manager_launcher.py --browser

class Launcher:
    home_directory = "/home/caiohman/repo/task_manager/"
    backend_directory = "backend/"
    frontend_directory = "frontend/"

    def __init__(self, params):
        
        if len(params) > 1 and params[1] == '--base':
            self.db_up()
            return
        
        if len(params) > 1 and params[1] == '--debug':
            self.debug()
            return
        
        if len(params) > 1 and params[1] == '--container':
            self.containers_up()
            return
        
        if len(params) > 1 and params[1] == '--browser':
            self.open_browser_container()
            return


    def debug(self): #run as user
        print('debug mode')

        backend_command = "node backend.js"
        frontend_command = "npm run dev"
        firefox_command = "firefox http://localhost:5173/" 
        
        self.run_command(backend_command, self.home_directory + self.backend_directory)
        self.run_command(frontend_command,  self.home_directory + self.frontend_directory)

        time.sleep(10)
        self.run_command(firefox_command,  self.home_directory)


    def run_command(self, command, directory):
        args = shlex.split(command)
        subprocess.Popen(args, cwd = directory, start_new_session=True)


    def containers_up(self): #run as sudo
        print('container mode')

        db_container = "sudo docker compose up db -d"
        backend_container = "sudo docker compose up backend -d"
        frontend_container = "sudo docker compose up frontend -d"

        self.run_command(db_container, self.home_directory)
        self.run_command(backend_container, self.home_directory)
        self.run_command(frontend_container,  self.home_directory)
 
    def db_up(self): #run as sudo
        db_container = "sudo docker compose up db -d"
        self.run_command(db_container, self.home_directory)

    def open_browser_container(self): #run as user
        firefox_command = "firefox http://localhost:8080/"
        self.run_command(firefox_command,  self.home_directory)


if __name__== '__main__':
    Launcher(sys.argv)           