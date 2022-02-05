#!/bin/bash

orca_ver=5.0.2
openmpi_ver=4.1.1
orca_path="/opt/orca-${orca_ver}/orca-${orca_ver}"
openmpi_path="/opt/orca-${orca_ver}/openmpi-${openmpi_ver}"

backup_file() {
	if [[ -e "${1}" ]]; then
		if [[ -e "${1}.bak" ]]; then
			backup_file "${1}.bak"
		fi
		mv "${1}" "${1}.bak"
	fi
}

export TMPDIR=/tmp
    

if [[ ! -x "${orca_path}/orca" ]]; then
  echo "ORCA not found." >&2
  return 1
fi
if [[ ! -d "${openmpi_path}/lib" ]]; then
  echo "OpenMPI "${openmpi_ver}" not installed." >&2
  return 2
fi

orca() {
  for file1 in "$@"; do	
	backup_file "${file1}.log"
    "${orca_path}/orca" "${file1}" > "${file1}.log"; 
  done; 
}

if [[ ! ${PATH} =~ ${openmpi_path} ]]; then
  export PATH="${openmpi_path}/bin"${PATH:+":$PATH"}
fi
if [[ ! ${LD_LIBRARY_PATH} =~ ${orca_path} ]]; then  
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+"${LD_LIBRARY_PATH}:"}${orca_path}
fi
if [[ ! ${LD_LIBRARY_PATH} =~ "${openmpi_path}/lib" ]]; then  
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+"${LD_LIBRARY_PATH}:"}"${openmpi_path}/lib"
fi
