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

  for(int i=0;i<list.length;i++) {
   element = list[i];
   File ff = new File(directory+'/'+element);
   el = ff.getName();
   fpath = ff.getPath();
   if (ff.isFile()) {
      fd = 0;
      fsize=ff.length();
   } else {
      fd = 1;
      fsize = null;
   }
   #sql{ INSERT INTO DIR_LIST_EXT(FILENAME,fd,fsize,fpath) VALUES (:el,:fd,:fsize,:fpath)};
  }
 }
}