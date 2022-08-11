import os
import shutil as sh

if __name__=="__main__":
    # fileroot 为你的data文件夹所在的绝对路径，最好不要使用相对路径，如"./data"等
    fileroot = "/Users/Zeila/Desktop/data/"
    # targetroot 具体可以填写你想要存放的文件夹，需要提前创建好
    targetroot = "/Users/Zeila/Desktop/target/"

    # 这里使用递增的方式来重新命名,也可以使用时间戳方式
    index = 1

    

            
    for curDir,dirs,files in os.walk(fileroot):
        
        for file in files:
            #print(file)
            if file.endswith("m=1_t0=0.0_mu=0.0_OBC_Bvary.txt"):
                #print(os.path.join(curDir, file))
                currentfile = os.path.join(curDir, file)
                print(len(str(curDir)))
                print(str(curDir[26::]))

                new_filename = str(curDir[26::])+".txt"
                
                index += 1

                targetfile = os.path.join(targetroot, new_filename)
                sh.copyfile(currentfile,targetfile)

    print("总共复制文件数",index-1)
