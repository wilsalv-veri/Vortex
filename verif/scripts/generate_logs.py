
import os
import sys

VORTEX = os.environ["VORTEX"]
dsim_log = "dsim.log"
test_runs_path = f"{VORTEX}/test_runs"
cwd_path = os.getcwd()
    
class VX_log:

    def __init__(self,name, match_string):
        self.name         = VX_log.get_formated_name(name)
        self.lines        = []
        self.match_string = match_string
        
    def add_line(self, line):
        self.lines.append(line)

    def write_log(self, test_run_path):
        log_path = f"{test_run_path}/{self.name}"

        with open(log_path, 'w') as file:
            file.writelines(self.lines)

    @staticmethod
    def get_formated_name(name):
        return f"VX_{name}.log"

def generate_logs(test_run_path):

    func_log_keys =["SEQ","SCBD","MONITOR"] 
    err_log_keys = ["ERROR", "FATAL"]

    logs = {}
    for key in func_log_keys:
        logs[key] = VX_log(key.lower(), key)
    
    
    logs["PASS_FAIL"] = VX_log("PASS_FAIL".lower(), "PASS_FAIL")

    filepath = f"{VORTEX}/output/{dsim_log}"
    try:
        with open(filepath, 'r') as file:
            for line in file:
                for key in func_log_keys:
                    if key in line:
                        logs[key].add_line(line)
                
                for key in err_log_keys:
                    if key in line:
                        logs["PASS_FAIL"].add_line(line)


    except FileNotFoundError:
        print(f"Error: The file '{filepath}' was not found.")


    for key in logs:

        if key == "PASS_FAIL":
            new_name = key.split("_")
            new_name_idx = int(len(logs[key].lines) > 2)
            new_formated_name = VX_log.get_formated_name(new_name[new_name_idx].lower())
            logs[key].name = new_formated_name

        logs[key].write_log(test_run_path)

if __name__ == "__main__":

    test_run_path = sys.argv[1]
    generate_logs(test_run_path)
