/* Generated by Together */

package com.dimata.instant.util;

import java.io.*;

public class DSJ_FilenameFilter implements FilenameFilter
{


	public boolean accept(File dir, String name) {
        if( (name!=null) && (name.startsWith(fileNameStart)))
            return true;
        else
            return false;

    }

    public String getFileNameStart(){ return fileNameStart; }

    public void setFileNameStart(String fileNameStart){ this.fileNameStart = fileNameStart; }

    private String fileNameStart="";
}
