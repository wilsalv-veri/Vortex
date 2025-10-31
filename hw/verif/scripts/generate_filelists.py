import os 

PROJECT_NAME = "VORTEX"
project_path = os.getenv(PROJECT_NAME)+'/hw' 
project_env_var = f"${PROJECT_NAME}"


def generate_filelist(file_name, lines):


    filelists_directory =  f"{project_path}/verif/filelists"
    abs_path_file_name = f"{filelists_directory}/{file_name}"   
    print(f"ABS_PATH_FILE_NAME:{abs_path_file_name}")
    with open(abs_path_file_name, 'w') as f:
        for line in lines:
            f.write(line + '\n')

def generate_top_filelist_lines(filelist_names):
    lines = []
    lines.append("// Set the include path for UVM macros and other files")
    lines.append("+incdir+$UVM_HOME/src")
    lines.append("// Add the UVM package file. It is crucial to compile this before any")
    lines.append("// files that depend on it")
    lines.append(f"-f {project_env_var}/hw/verif/filelists/{filelist_names[0]}")
    lines.append("$UVM_HOME/src/uvm_pkg.sv")
    lines.append("+define+NOPAE")
    lines.append("+define+GBAR_ENABLE")
    lines.append("+define+LMEM_ENABLED")
    lines.append("\n//Reference other filelists")
    
    for filelist_name in filelist_names[1:]:
        lines.append(f"-f {project_env_var}/hw/verif/filelists/{filelist_name}")


    return lines

def addLinesUnderCurrentDirectory(cwd_path,include_files):
        
        supported_formats = ["vh","sv","v", "dir"]
        #entries = os.listdir(cwd_path)
        if 'opae' in cwd_path:
            return
        
        entries = []
        file_entries = [entry for entry in os.listdir(cwd_path) if os.path.isfile(os.path.join(cwd_path, entry))]
        dir_entries = [entry for entry in os.listdir(cwd_path) if os.path.isdir(os.path.join(cwd_path, entry))]
        
        sort_by_match(file_entries, "_pkg")
        sort_by_match(file_entries, ".vh")
        
        entries.extend(file_entries)
        entries.extend(dir_entries)
        #print(f"Entries in '{cwd_path}':")
        for entry in entries:
            #os.path.isfile(os.path.join(rtl_path, entry))
            
            abs_path = os.path.join(cwd_path, entry)
            directory = os.path.isdir(abs_path)
            path = abs_path.replace(entry,"")

            if not directory:
                format = entry.split(".")[1]
            else:
                format = "dir"
            
            if directory:
                entry = ensure_dependent_order(entry)
                abs_path = os.path.join(cwd_path, entry)
                directory = os.path.isdir(abs_path)
                path = abs_path.replace(entry,"")


            if entry[0] == "." or ((not directory) and (format not in supported_formats)) :
                continue
            
                
            includeLine = filelistIncludeLine(entry, path, directory)
            includeLine.add_line(include_files)
        
            if directory:
                addLinesUnderCurrentDirectory(abs_path, include_files)
                include_files.append("\n")

def ensure_dependent_order(dir_name):
    #FPU Must come before Interface directory
    #VX_fpu_pkg dependency for fpu interfaces
    swap_positions_dict = {"fpu": "interfaces" , "interfaces": "fpu"}

    if dir_name in swap_positions_dict:
        return swap_positions_dict[dir_name]
    else:
        return dir_name


def get_real_dir_name(dir_name):
    
    if "/" in dir_name:
        dir_name = dir_name.split("/")[-1]
    
    return dir_name

def sort_by_match(file_entries, match_string=".vh"):

    copy_entries = file_entries.copy()
    
    for idx, entry in enumerate(copy_entries):
        if match_string in entry:
            file_entries.pop(idx)
            file_entries.insert(0,entry)
        
class filelistIncludeLine:

    def __init__(self, name, abs_path="",directory=False ):
        self.header = ""
        self.name = name
        self.abs_path = abs_path
        self.rel_path = None
        self.rel_path_set = False
        self.set_rel_path()
        self.directory = directory
        
    def add_line(self, lineList):
        filePath = f"{self.rel_path}{self.name}"

        if self.directory:
            lineList.append(f"\n//Include Files under {filePath}")
        
        line = [filePath,f"+incdir+{filePath}\n"][int(self.directory)]
        lineList.append(line)
    
    def set_rel_path(self):
        
        if not self.rel_path_set:
            project_dir = "Vortex"
            project_dir_indx = self.abs_path.index(project_dir)
            self.rel_path = self.abs_path.replace( self.abs_path[0:project_dir_indx + len(project_dir)],project_env_var)
            self.rel_path_set = True

if __name__ == "__main__":
    
    sim_params = f"{project_path}/verif/sim_params"
    rtl_path = f"{project_path}/rtl"
    dpi_path = f"{project_path}/dpi"
    tb_path = f"{project_path}/tb"
    
    paths = [sim_params, rtl_path,dpi_path, tb_path]
    filelist_names = []

    for path in paths:
        include_files = []

        dir_name = path[ path.index(project_path) + len(project_path) + 1:]
        dir_name = get_real_dir_name(dir_name)
        
        includeLine = filelistIncludeLine(dir_name, path.replace(dir_name,""), True)
        includeLine.add_line(include_files)    
        
        addLinesUnderCurrentDirectory(path,include_files)
        filelist_name = f"{dir_name}_filelist.f"
        filelist_names.append(filelist_name)
        generate_filelist(filelist_name, include_files)

    top_filelist_lines = generate_top_filelist_lines(filelist_names)
    generate_filelist("top_filelist.f",top_filelist_lines)