#!/usr/local_rwth/bin/zsh

for fileindex in $(seq 1 1 1)
do

dir='B'$fileindex
mkdir $dir
cd $dir
   cp ../t0.out ./

   touch run_individual

   echo "#!/usr/local_rwth/bin/bash" >> run_individual
   echo "#SBATCH --job-name=B$fileindex" >> run_individual
   echo "#SBATCH --output=output$fileindex.txt" >> run_individual
   echo "#SBATCH --ntasks=1" >> run_individual
   echo "#SBATCH --time=10:00:00 " >> run_individual
   echo "#SBATCH --cpus-per-task=48" >> run_individual
   echo "#SBATCH --mem=2000M " >> run_individual
   echo "#SBATCH --account=theophysc" >> run_individual
   #echo "#SBATCH --partition=ih" >> run_individual
   #echo "#SBATCH --partition=c18m" >> run_individual
   echo "module load intel/19.0" >> run_individual
   echo "./t0.out" >> run_individual

chmod +x run_individual
sbatch run_individual
$fileindex

cd ../
done

  
  
