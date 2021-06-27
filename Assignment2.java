import java.sql.*;

public class Assignment2 {
    
    // A connection to the database  
    Connection connection;
  
    // Statement to run queries
    Statement sql;
  
    // Prepared Statement
    PreparedStatement ps;
  
    // Resultset for the query
    ResultSet rs;
  
    //CONSTRUCTOR
    Assignment2() throws ClassNotFoundException{
    	
    	Class.forName("org.postgresql.Driver");
    }
  ////////////////////////////////////////////////////////////////////////////////////////
    //Using the input parameters, establish a connection to be used for this session. Returns true if connection is sucessful
    public boolean connectDB(String URL, String username, String password){
    	
    	try {
    		connection = DriverManager.getConnection(URL,username,password);
    		sql = connection.createStatement();
    		
    	}
    	catch(SQLException e)
    	{
    		return false;
    	}
    	
    	 return (connection!=null); 
    }
    
  /////////////////////////////////////////////////////////////////////////////
    //Closes the connection. Returns true if closure was successful
    public boolean disconnectDB(){
        try {
			if (connection != null && !connection.isClosed()) {
				connection.close();
			}
			if (sql != null && !sql.isClosed()) {
				sql.close();;							  
			} 
			else if(rs != null && !rs.isClosed()) 
			{
				rs.close();								 
			}
			else if(ps != null && !ps.isClosed())
			{
				ps.close();								  
			} 
			return (connection == null || connection.isClosed());
        }
        catch(SQLException e){
        	return false;
        }        
    }
    
    
    
    
    
    
    
   /////////////////////////////////////////////////////////////////////////////// 
    public boolean insertPlayer(int pid, String pname, int globalRank, int cid) {
     
    	try 
    	{
    		String ss = "select pid from player where pid = " +pid+";";
    		rs = sql.executeQuery(ss);
    		if(!rs.next()) {
    			String tt = "insert into player values ("+pid+  ",'"  +pname+ "'," +globalRank+ "," +cid+ ");"  ;
    			ps = connection.prepareStatement(tt);
    			int rowsaff = ps.executeUpdate();
    		
    			
    			
    			if(rowsaff == 1) {
    				return true;
    			}else {
    				return false;
    			}
    		}else {
    			return false;
    		}    		
    	}
    	
    	
    	catch(SQLException e)
    	{
    		 
    		return false;
    		
    	}
        
        
    }
    
    
    
    
    
  
    public int getChampions(int pid) {
    	try
    	{
	    	String ss ="select * from event e, champion c "
	    			+ " where e.lossid = c.pid and e.winid = "+pid+" ;";
	    	
	    	rs = sql.executeQuery(ss);
	    	
	    	int rowCount = 0;
	    	
	    	while ( rs.next() )
	    	{
	    	    rowCount++;
	    	}
	    	return rowCount;
    	}
    	catch(SQLException e)
    	{
    		 
    		return 0;
    	}

    }
    
    
    
    
    
    
   ///////////////////////////////////////////////////////////////////////////////
    public String getCourtInfo(int courtid){
    	try 
    	{
    		String ss =  "select court.courtid, court.courtname, court.capacity, tournament.tname "
    			+ "from court join tournament on court.tid = tournament.tid where court.courtid = "+ courtid +";";
    	
    		rs = sql.executeQuery(ss); 
	    	if(rs.next()) {
	    		return rs.getInt(1)+":"+rs.getString(2)+":"+rs.getString(3)+":"+rs.getInt(4);
	    		
	    	}
	    	else 
	    	{
	    		return "";
	    	}    	
    	}
    	catch(SQLException e) 
    	{
    		 
    		return "" ;
    	}
    	
        
    }
//////////////////////////////////////////////////////////////////////////////
    public boolean chgRecord(int pid, int year, int wins, int losses)
    {
        try 
        {
        	String ss = "update record set wins = "+wins+" , losses = "+losses+" where pid = "+pid+" and year = "+year+";";
        	
        	int rows = sql.executeUpdate(ss);
        	if(rows == 1)
        	{
        		return true;
        		
        	}
        	else
        	{
        		return false;
        	}
        }
        catch(SQLException e) 
        {
        	 
        	return false;
        }        
    }
/////////////////////////////////////////////////////////////////////////////////
    public boolean deleteMatchBetween(int p1id, int p2id){
       try 
       {
    	   String ss = "delete from event where (winid ="+p1id+" and lossid = "+p2id+" ) or (winid = "+p2id+" and lossid = "+p1id+" ) ;";
    	   int rows = sql.executeUpdate(ss);
    	   if(rows>0) 
    	   {
    		   return true;
    	   }
    	   else
    	   {
    		   return false;
    	   }
       }
       catch(SQLException e) 
       {
    	    
    	   return false;   
       }
    }
    
    
    
  
    public String listPlayerRanking(){
	    try
	    {
	    	
	    	// BECAUSE YOU SAID DESCENDING ORDER ON ASSIGNMENT//
	    	String ss = "select pname, globalrank from player order by globalrank desc"; 
	    	rs = sql.executeQuery(ss);
	    	String rr = "";
	    	while(rs.next())
	    	{
	    		rr = rr+rs.getString(1)+":"+rs.getInt(2)+"\n";
	    	}
	    	return rr;
    	
    	
	    }
	    catch(SQLException  e)
	    {
	    	 
	    	return "";
	    }	      
    }


  
    public int findTriCircle(){
    	
    	try
    	{
	    	String ss = " select a.lossid, b.winid, b.lossid, c.winid, c.lossid, a.winid " + 
	    			" from event a, event b, event c " + 
	    			" where a.lossid = b.winid and b.lossid = c.winid and c.lossid = a.winid ; ";
	    	
	    	rs = sql.executeQuery(ss);
	    	
	    	int rowCount = 0;
	    	
	    	while ( rs.next() )
	    	{
	    	    rowCount++;
	    	}
	    	
	    	
	    	
	    	if(rowCount>0) 
	    	{
	    		int actucount = rowCount/3;
	    		return actucount;
	    	}
	    	else
	    	{
	    		return 0;
	    	}
    	}
    	catch(SQLException e)
    	{
    		 
    		return 0;
    	}
    }
    
    
    
 /////////////////////////////////////////////////////////////////////////////////////////   
    public boolean updateDB(){
	    try 
	    {      
	    	String ct = "create table if not exists championPlayers (pid int not null , pname varchar(100),  nchampions int);" ;
	    	String ins = "insert into championPlayers( select player.pid as pid, player.pname as pname, count(champion.pid) as nchampions"
	    			+ " from player join champion on player.pid=champion.pid group by player.pid);";
	    	sql.executeUpdate(ct);
		    int rows = sql.executeUpdate(ins);
		    
		    if(rows>0)
		    {
		    	return true;
		    }
		    else
		    {
		    	return false;
		    }
	    
	    }  
	    catch(SQLException e)
	    {
	    	 
	    	return false;	    	
	    }	      
    }  
    
    

    
}
