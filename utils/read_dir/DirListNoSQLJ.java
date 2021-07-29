// Get list directory contents Oracle Database, PL/SQL, Java).
// For ORACLE >= 12.1.0.2
import java.io.*;
import java.sql.*;

public class DirList_ext {
  public static void getList(String directory) throws SQLException {
    Connection conn = DriverManager.getConnection("jdbc:default:connection:");
    String sql = "INSERT INTO DIR_LIST_EXT (FD , FILENAME , FSIZE  , FPATH  , MODIF) values (?,?,?,?,?)";
    
    File path=new File(directory);
    String[] list=path.list();

    PreparedStatement pstmt = conn.prepareStatement(sql);
    for (int i=0; i < list.length; i++) {
      File ff = new File(directory + '/' + list[i]);
      int isDirectory = (ff.isFile() == true)? 0 : 1;

      pstmt.setInt(1, isDirectory);
      pstmt.setString(2,  ff.getName());
      pstmt.setLong(3, ff.length());
      pstmt.setString(4, ff.getPath());
      pstmt.setLong(5, ff.lastModified());
      pstmt.executeUpdate();
    }
    pstmt.close();
  }
}