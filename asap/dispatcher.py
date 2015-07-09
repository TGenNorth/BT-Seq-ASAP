'''
Created on Jul 8, 2015

@author: Darrin Lemmer
'''

import logging

def _submit_job(job_submitter, command, job_parms, waitfor_id=None, hold=False, notify=False):
    import subprocess
    import re
    import os

    # TODO(jtravis): remove unused output variable
    output = jobid = None
    logging.info("command = %s" % command)
    if job_submitter == "PBS":
        waitfor = ""
        if waitfor_id:
            dependency_string = waitfor_id[1] if len(waitfor_id) > 1 else 'afterok'
            waitfor = "-W depend=%s:%s" % (dependency_string, waitfor_id[0])
        queue = ""
        if job_parms["queue"]:
            queue = "-q %s" % job_parms["queue"]
        args = job_parms["args"]
        if hold:
            args += " -h"
        if notify:
            args += " -m e"
        submit_command = "qsub -V -d \'%s\' -w \'%s\' -l ncpus=%s,mem=%sgb,walltime=%s:00:00 -m a -N \'%s\' %s %s %s" % (
            job_parms["work_dir"], job_parms["work_dir"], job_parms['num_cpus'], job_parms['mem_requested'],
            job_parms['walltime'], job_parms['name'], waitfor, queue, args)
        logging.debug("submit_command = %s", submit_command)
        output = subprocess.getoutput("echo \"%s\" | %s - " % (command, submit_command))
        logging.debug("output = %s" % output)
        job_match = re.search('^(\d+)\..*$', output)
        if job_match:
            jobid = job_match.group(1)
        else:
            logging.warning("Job not submitted!!")
            print("WARNING: Job not submitted: %s" % output)
    elif job_submitter == "SLURM":
        waitfor = ""
        if waitfor_id:
            dependency_string = waitfor_id[1] if len(waitfor_id) > 1 else 'afterok'
            waitfor = "-d %s:%s" % (dependency_string, waitfor_id[0])
        queue = ""
        if job_parms["queue"]:
            queue = "-p %s" % job_parms["queue"]
        args = job_parms["args"]
        if hold:
            args += " -H"
        if notify:
            args += " --mail-type=END"
        submit_command = "sbatch -D \'%s\' -c%s --mem=%s000 --time=%s:00:00 --mail-type=FAIL -J \'%s\' %s %s %s" % (
            job_parms["work_dir"], job_parms['num_cpus'], job_parms['mem_requested'], job_parms['walltime'],
            job_parms['name'], waitfor, queue, args)
        logging.debug("submit_command = %s" % submit_command)
        output = subprocess.getoutput("%s --wrap=\"%s\"" % (submit_command, command))
        logging.debug("output = %s" % output)
        job_match = re.search('^Submitted batch job (\d+)$', output)
        if job_match:
            jobid = job_match.group(1)
        else:
            logging.warning("Job not submitted!!")
            print("WARNING: Job not submitted: %s" % output)
    elif job_submitter == "SGE":
        waitfor = ""
        if waitfor_id:
            waitfor = "-hold_jid %s" % (re.sub(":", ",", waitfor_id[0]))
        queue = ""
        if job_parms["queue"]:
            queue = "-q %s" % job_parms["queue"]
        args = job_parms["args"]
        if hold:
            args += " -h"
        if notify:
            args += " -m e"
        mem_needed = float(job_parms['mem_requested']) * 1024 * 1024
        # Apparently the number of processors a job uses is controlled by the queue it is running on in SGE, so there is no way to request a specific number of CPUs??
        submit_command = "qsub -V -cwd \'%s\' -wd \'%s\' -l h_data=%sgb,h_rt=%s:00:00 -m a -N \'%s\' %s %s %s" % (
            job_parms["work_dir"], job_parms["work_dir"], mem_needed, job_parms['walltime'], job_parms['name'], waitfor,
            queue, args)
        logging.debug("submit_command = %s", submit_command)
        output = subprocess.getoutput("echo \"%s\" | %s - " % (command, submit_command))
        logging.debug("output = %s" % output)
        job_match = re.search('^(\d+)\..*$', output)
        if job_match:
            jobid = job_match.group(1)
        else:
            logging.warning("Job not submitted!!")
            print("WARNING: Job not submitted: %s" % output)
    else:
        command = re.sub('\n', '; ', command)
        work_dir = job_parms['work_dir']
        dependency_check = ""
        if waitfor_id:
            if re.search(":", waitfor_id[0]):
                pid_filename = os.path.join(work_dir, "%s_dependent_pids" % job_parms['name'])
                pid_file = open(pid_filename, 'w')
                pids = waitfor_id[0].split(":")
                pid_file.write("\n".join(pids))
                pid_file.close()
                dependency_check = "while [ -s %s ]; do sleep 600; for pid in `cat %s`; do kill -0 \"$pid\" 2>/dev/null || sed -i \"/^$pid$/d\" %s; done; done; rm %s; " % (
                    pid_filename, pid_filename, pid_filename, pid_filename)
            else:
                pid = waitfor_id[0]
                dependency_check = "while kill -0 %s; do sleep 300; done; " % pid
        # cpu_check = "grep 'cpu ' /proc/stat | awk '{usage=($2+$4)/($2+$4+$5)} END {print 1-usage}'"
        total_mem = subprocess.getoutput("free -g | grep Mem: | awk '{ print $2 }'")
        mem_requested = job_parms['mem_requested']
        if mem_requested > total_mem:
            mem_requested = total_mem
        print("total_mem = %s" % total_mem)
        mem_needed = float(mem_requested) * 750
        mem_check = "while [ `free -m | grep cache: | awk '{ print $4 }'` -lt %d ]; do sleep 300; done; " % mem_needed
        submit_command = "%s%s%s" % (dependency_check, mem_check, command)
        logging.debug("submit_command = %s" % submit_command)
        output_log = os.open(os.path.join(work_dir, "%s.out" % job_parms['name']), os.O_WRONLY | os.O_CREAT)
        proc = subprocess.Popen(submit_command, stderr=subprocess.STDOUT, stdout=output_log, shell=True, cwd=work_dir)
        jobid = str(proc.pid)
    logging.info("jobid = %s" % jobid)
    return jobid

def findReads(path):
    import os
    import re
    read_list = []
    for file in os.listdir(path):
        is_read = re.search('(.*)(\.fastq(?:\.gz)?)$', file, re.IGNORECASE)
        if is_read:
            sample_name = is_read.group(1)
            is_paired = re.search('^((.*?)(?:_L\d\d\d)?(?:_[R]?))([12])(.*)$', sample_name, re.IGNORECASE)
            if is_paired:
                if is_paired.group(3) == '1':  # If paired, only process read 1, so we don't double count the pair, see TODO below
                    sample_name = is_paired.group(2)
                    read1 = file
                    read2 = "%s2%s%s" % (is_paired.group(1), is_paired.group(4), is_read.group(2))
                    if os.path.exists(os.path.join(path, read2)):
                        read = (sample_name, os.path.join(path, read1), os.path.join(path, read2))
                        read_list.append(read)
                        logging.info(read)
                    else:
                        # TODO: If only R2 exists, it won't be included
                        logging.warning("Cannot find %s, the matching read to %s. Including as unpaired..." % (read2, read1))
                        read = (sample_name, os.path.join(path, read1))
                        read_list.append(read)
                        logging.info(read)
            else:
                read = (sample_name, os.path.join(path, file))
                read_list.append(read)
                logging.info(read)
    return read_list

def trimAdapters(sample, read1, read2=None, quality=None, adapters="../illumina_adapters_all.fasta", minlen=80):
    import os
    job_params = {'queue':'', 'mem_requested':3, 'num_cpus':1, 'walltime':8, 'args':''}
    job_params['name'] = "asap_trim_%s" % sample
    job_params['work_dir'] = os.path.dirname(read1)
    qual_string = quality if quality else ''
    if read2:
        out_reads = [sample+"_R1_trimmed.fastq", sample+"_R1_unpaired.fastq", sample+"_R2_trimmed.fastq", sample+"_R2_unpaired.fastq"]
        command = "java -jar /scratch/bin/trimmomatic-0.32.jar PE %s %s %s %s %s $%s ILLUMINACLIP:%s:2:30:10 %s MINLEN:%d" % (read1, read2, out_reads[0], out_reads[1], out_reads[2], out_reads[3], adapters, qual_string, minlen)
    else:
        out_reads = [sample+"_trimmed.fastq"]
        command = "java -jar /scratch/bin/trimmomatic-0.32.jar SE %s %s ILLUMINACLIP:%s:2:30:10 %s MINLEN:%d" % (read1, out_reads[0], adapters, qual_string, minlen)
    jobid = _submit_job('PBS', command, job_params)
    #jobid=1
    #print(command)
    return (sample, jobid, out_reads)

if __name__ == '__main__':
    pass