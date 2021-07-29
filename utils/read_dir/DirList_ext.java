// Get list directory contents Oracle Database, PL/SQL, Java).
// For ORACLE < 12.1.0.2
import java.io.*;
import java.sql.*;

public class DirList_ext {
   public static void getList(String directory) throws SQLException {
      File path=new File(directory);
      String[] list=path.list();
      String element;
      String el;
      Integer fd;
      Long fsize;
      String fpath;

      for (int i=0; i < list.length; i++) {
         element = list[i];
         File ff = new File(directory+'/'+element);
         fileName = ff.getName();
         fpath = ff.getPath();
         int isDirectory = (fileObj.isFile() == true)? 0 : 1;
         fsize = ff.length();
         Long lastModified = ff.lastModified()''
         #sql{ INSERT INTO DIR_LIST_EXT(FD , FILENAME , FSIZE  , FPATH  , MODIF) VALUES (:isDirectory, :fileName, :fsize, :fpath, :lastModified)};
      }
   }
}