// Get list directory contents Oracle Database, PL/SQL, Java).
// For ORACLE >= 12.1.0.2 and JAVA version >= 1.7
// The FASTEST Java function method with the ability to specify how many files to read.

// For even greater speed, you can remove the File class, which extracts the meta data of the file.
create or replace and COMPILE JAVA SOURCE NAMED "DirList_ext" as
import java.io.*;
import java.sql.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class DirList_ext {
	public static void getList(String directory, Integer limit) throws SQLException {
        int fileCounter = 0;
        
        Connection conn = DriverManager.getConnection("jdbc:default:connection:");
        String sql = "INSERT into DIR_LIST_EXT (FD , FILENAME , FSIZE  , FPATH  , MODIF ) values (?,?,?,?,?)";
        
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            for (Path path : Files.newDirectoryStream(Paths.get(directory))) {
                
                Path fileName = path.getFileName();
                File fileObj = path.toFile();
                int isDirectory = (fileObj.isFile() == true)? 0 : 1;
                
                pstmt.setInt(1, isDirectory);
                pstmt.setString(2, fileName.toString());
                pstmt.setLong(3, fileObj.length());
                pstmt.setString(4, fileObj.toString());
                pstmt.setLong(5, fileObj.lastModified());
                pstmt.executeUpdate();
                
                fileCounter++;
                if ((limit != 0) & (fileCounter >= limit)) {
                    break;
                }
            }
            pstmt.close();
        } catch(IOException e) {
            throw new SQLException(e);
        }
    }
}
