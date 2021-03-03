//
//  File.swift
//  
//
//  Created by Rm1210 on 2021/3/3.
//

import PathKit
import Rainbow
import FengNiaoKit
import Foundation

public func writeResultToOutput(files: [FileInfo], output: String) -> Bool {
    
    let dirPath = Path(output)
    
    if !dirPath.exists {
        do {
            try dirPath.mkdir()
        } catch {
            print("新建保存结果的文件夹失败！".red.bold)
            exit(EX_USAGE)
        }
    } else if dirPath.isFile {
        print("项目根目录有同名文件，无法新建保存结果的文件夹！".red.bold)
        exit(EX_USAGE)
    }
    
    let size = files.reduce(0) { $0 + $1.size }.fn_readableSize
    let summary = "\(files.count) unused files are found. Total Size: \(size)"
    
    var resultToWrite = "\n\n\(summary)\n\n"
    for file in files.sorted(by: { $0.size > $1.size }) {
        let item = "\(file.readableSize) \(file.path.string)\n"
        resultToWrite.append(item)
    }
    
    let txtPath = dirPath + Path("unusedResources.txt")
    
    if !txtPath.exists {
        FileManager.default.createFile(atPath: txtPath.string, contents: nil, attributes: nil)
    } else if txtPath.isDirectory {
        print("保存结果的文件夹内有以 unusedResources.txt 命名的文件夹，请改名！".red.bold)
        exit(EX_USAGE)
    }
    

    do {
        try txtPath.write("")
        try txtPath.write(resultToWrite)
    } catch {
        print("结果写入 \(txtPath.string) 失败！".red.bold)
    }
    
    return true
}
