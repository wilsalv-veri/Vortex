import os 

PROJECT_NAME = "VORTEX"
project_path = os.getenv(PROJECT_NAME)+'/hw' 
project_env_var = f"${PROJECT_NAME}"

generate_filelist_path = os.path.abspath(__file__)
scripts_dir = os.path.dirname(generate_filelist_path)

def generate_filelist(file_name, lines):
    filelists_directory =  f"{project_path}/verif/filelists"
    abs_path_file_name = f"{filelists_directory}/{file_name}"   
    print(f"ABS_PATH_FILE_NAME:{abs_path_file_name}")
    with open(abs_path_file_name, 'w') as f:
        for line in lines:
            f.write(line  + '\n' )

def generate_top_filelist_lines(filelist_names):
    top_level_lines = []
    top_level_lines.append(f"-f {project_env_var}/hw/verif/filelists/{filelist_names[0]}\n")
    top_level_lines.append("// Set the include path for UVM macros and other files")
    top_level_lines.append("+incdir+$UVM_HOME/src\n")
    top_level_lines.append("// Add the UVM package file. It is crucial to compile this before any")
    top_level_lines.append("// files that depend on it")
    top_level_lines.append("$UVM_HOME/src/uvm_pkg.sv\n")
    
    with open(f"{scripts_dir}/top_level_macros.txt", "r") as file:
        for macro in file:
            top_level_lines.append(f"+define+{macro.replace("\n","")}")

    top_level_lines.append("\n//Reference other filelists")
    
    for filelist_name in filelist_names[1:]:
        top_level_lines.append(f"-f {project_env_var}/hw/verif/filelists/{filelist_name}")

    return top_level_lines

def addLinesUnderCurrentDirectory(cwd_path,include_files):
        
        supported_formats = ["vh","svh","sv","v", "dir"]
        cwd = get_current_dir_name(cwd_path)

        dont_include_files_under_dir_list = ['opae', 'VX_risc_v_agent']
        
        if cwd in dont_include_files_under_dir_list:
            return

        entries = []
        file_entries = [entry for entry in os.listdir(cwd_path) if os.path.isfile(os.path.join(cwd_path, entry))]
        dir_entries = [entry for entry in os.listdir(cwd_path) if os.path.isdir(os.path.join(cwd_path, entry))]
        
        if cwd == 'tb':
            sort_by_match(dir_entries, "tests")
            sort_by_match(dir_entries, "seqs")
            sort_by_match(dir_entries, "scoreboards")
            sort_by_match(dir_entries, "agents")
            sort_by_match(dir_entries, "memory_model")
            sort_by_match(dir_entries, "interfaces")
            sort_by_match(dir_entries, "common")
            sort_by_match(dir_entries, "packages")
        elif cwd == 'packages':
            sort_by_match(file_entries, "gpr_pkg") 
            sort_by_match(file_entries, "common_pkg")      
        elif cwd == 'seqs':
            sort_by_match(dir_entries, "base_seqs", inc_order=False)
        elif "seqs" in cwd:
            sort_by_match(file_entries, "seq_lib")
            sort_by_match(file_entries, "doa_seq_lib")
            sort_by_match(file_entries, "rtg_seq.sv")
            sort_by_match(file_entries, "doa_seq.sv")
        elif cwd == 'tests':
            sort_by_match(dir_entries, "base_tests",inc_order=False)
        if cwd != 'packages':
            sort_by_match(file_entries, "_pkg")
            sort_by_match(file_entries, ".vh")
            sort_by_match(file_entries, ".svh")
         
        entries.extend(file_entries)
        entries.extend(dir_entries)

        for entry in entries:
            
            abs_path = os.path.join(cwd_path, entry)
            directory = os.path.isdir(abs_path)
            path = abs_path.replace(entry,"")

            if not directory:
                format = entry.split(".")[1]
            else:
                format = "dir"
            
            if ((cwd == 'rtl') and directory):
                entry = ensure_dependent_order(entry)
                abs_path = os.path.join(cwd_path, entry)
                directory = os.path.isdir(abs_path)
                path = abs_path.replace(entry,"")
    
            if not len(entry):
                continue
            
            skip_list = []
            skip_list.append(entry[0] == ".") #hidden files
            skip_list.append(format not in supported_formats) #unsupported_format
            skip_list.append((cwd == 'common') and (not directory) and ('environment' not in entry)) #common_pkg_files
            skip_list.append(cwd == 'seq_items')
            skip_list.append(cwd == 'base_seqs')
            skip_list.append(cwd == 'scoreboards')
            skip_list.append(cwd == 'interface_connections')
            skip_list.append(cwd == 'transaction_items')
            skip_list.append('_agent' in cwd)
            
            if True in skip_list:
                continue          
            
            includeLine = filelistIncludeLine(entry, path, directory)
            includeLine.add_line(include_files)
        
            if directory:
                addLinesUnderCurrentDirectory(abs_path, include_files)
                include_files.append("")

        if cwd == 'tb':
             sort_by_match(include_files, "tb_top.sv", False)

def ensure_dependent_order(dir_name):
    #FPU Must come before Interface directory
    #VX_fpu_pkg dependency for fpu interfaces
    swap_positions_dict = {"fpu": "interfaces" , "interfaces": "fpu"}

    if dir_name in swap_positions_dict:
        return swap_positions_dict[dir_name]
    else:
        return dir_name


def get_current_dir_name(dir_name):
    
    if "/" in dir_name:
        dir_name = dir_name.split("/")[-1]
    
    return dir_name

def sort_by_match(file_entries, match_string=".vh", inc_order=True):

    copy_entries = file_entries.copy()
    insert_idx_dict = {True:0,False:-1}
    inserted_new_line = False

    for idx, entry in enumerate(copy_entries):
        if match_string in entry:
            file_entries.pop(idx)

            #if not inc_order and not inserted_new_line:
            #    file_entries.insert(insert_idx_dict[inc_order], "")
            #    inserted_new_line = True

            file_entries.insert(insert_idx_dict[inc_order],entry)
        
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
            lineList.append(f"//Include Files under {filePath}")
        
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
        dir_name = get_current_dir_name(dir_name)
        
        includeLine = filelistIncludeLine(dir_name, path.replace(dir_name,""), True)
        includeLine.add_line(include_files)    
        
        addLinesUnderCurrentDirectory(path,include_files)
        filelist_name = f"{dir_name}_filelist.f"
        filelist_names.append(filelist_name)
        generate_filelist(filelist_name, include_files)

    top_filelist_lines = generate_top_filelist_lines(filelist_names)
    generate_filelist("top_filelist.f",top_filelist_lines)