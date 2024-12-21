import shlex,subprocess, sys

class Laucher:

    home_directory = "/home/caiohman/repo/task_manager/"
    backend_directory = "backend/"
    frontend_directory = "frontend/"

    def __init__(self, params):
        db_container = "sudo docker compose up db -d"

        #self.run_command(db_container, self.home_directory)

        if len(params) > 1 and params[1] == '--debug':
            self.debug()


    def debug(self):
        print('debug mode')

        backend_command = "node backend.js"
        frontend_command = "npm run dev" 
        
        self.run_command(backend_command, self.home_directory + self.backend_directory)
        self.run_command(frontend_command,  self.home_directory + self.frontend_directory)


    def run_command(self, command, directory):
        args = shlex.split(command)
        subprocess.Popen(args, cwd = directory, start_new_session=True)


if __name__== '__main__':
    Laucher(sys.argv)           