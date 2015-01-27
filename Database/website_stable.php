
<!DOCTYPE html>
	<head>
		<style>

		    html, body {
		    	height: 100%;
		    }

			.center {
				margin-left: auto;
				margin-right: auto;
				width: 100%;
				background-color: #d0e4fe;
			}

			body {
				background-color: #d0e4fe;
				height: 100%;
			}

			h1 {
				text-align: center;
			}

			p {
				font-family: "Times New Roman";
				font-size: 20px;
			}

			#results {
				font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
				width: 75%;
				border-collapse: collapse;
				border: 2px solid black;
			}

			#command {
				margin-left: auto;
				margin-right: auto;
				width: 100%
			}
			#command table {
				width: 100%;
			}
			#command td {
				text-align: center;
				padding: 0;
			}

			#code {
				font-family: "Courier New", Arial, Helvetica, sans-serif;
				font-size: medium;
			}

			td, th {
				padding: 10px;
			}

			#results tr.alt td {
				color: #000000;
				background-color: #b0e0e6;
			}

			#results td {
				text-align: left;
				border: 1px solid black;
				padding: 10px;
			}

			th {
				background-color: black;
				color: white;
			}

			caption {
				caption-side: top;
			}

			.prompt{
				text-align: center;
			}
			#good{
				text-align: center;
				color: green;
				font-size: x-large;

			}
			#bad{
				text-align: center;
				color: red;
				font-size: x-large;
			}

			input[type="text"]{
				width: 400px;
				text-align: center;
				font-family: "Courier New", Arial, Helvetica, sans-serif;
				font-size: small;
			}

			.wrapper {
			    min-height: 100%;
			    height: auto !important;
			    height: 100%;
			    margin: 0 auto -4em;
    		}
    		#cw {
    			text-align: center;
    			font-size: medium;

    		}
		    .footer, .push {
		    	margin-left: auto;
		    	margin-right: auto;
		    	width: 100%;
   				height: 4em;
    		}

    		#st {
				text-align: center;
				color: black;
				font-size: large;
				font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;

    		}


		</style>
		<title>Update a Record in MySQL Database</title>
	</head>
	<body>
	<div class="wrapper">
		<form method="post" action="<?php $_PHP_SELF ?>" id="command">
			<table cellspacing="1" cellpadding="2">
				<tr><td><h1>SQL Query</h1></td></tr>
				<tr><td><input name="sql_command" type="text" id="sql_command"></td></tr>
				<tr>
					<td>
						<select name="queries">
						<option value="0" select="selected">Default Queries</option>
						<option value="1" select="selected">1</option>
						<option value="2" select="selected">2</option>
						<option value="3" select="selected">3</option>
						<option value="4" select="selected">4</option>
						<option value="5" select="selected">5</option>
						<option value="6" select="selected">6</option>
						<option value="7" select="selected">7</option>
						<option value="8" select="selected">8</option>
						<option value="9" select="selected">9</option>
						<option value="10" select="selected">10</option>
						<option value="11" select="selected">11</option>
						<option value="12" select="selected">12</option>	
						<option value="14" select="selected">Describe all</option>				
						<option value="15" select="selected">Show PKs & FKs</option>				
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<input name="update" type="submit" id="update" value="Submit">
					</td>
				</tr>
			</table>
		</form>

		<?php
			if(isset($_POST['update']))
			{
				$dbhost = 'localhost:/tmp/mysql.sock';//'128.138.202.118';
				$dbuser = 'jacob';//'jacob.rail';
				$dbpass = '';//'lum1nousB0ssMoss16@';
				$dbname = 'test';
				$con = mysql_connect($dbhost, $dbuser, $dbpass);
				if(! $con )
				{
					die('<p id="bad">Could not connect to MySQL Database: '.mysql_error().'.</p>'."<div class='push'></div></div>".'<div class="footer"><p id="cw"> Copyright (c) 2014. Property of Jacob Rail </p></div>');
				}

				$querie = $_POST['queries'];
				//$sql = $_POST['sql_command'];

				$default_querie_prompt = 'Using default querie #'.$querie;

				if($querie==1){
					$sql_array = array("SELECT * FROM observations WHERE Latitude > 0 ORDER BY Longitude");
				}
				else if($querie==2){
					$sql_array = array("SELECT * FROM observations WHERE Latitude > 0 ORDER BY Longitude LIMIT 2");
				}
				else if($querie==3){
					$sql_array = array("SELECT tests.TestID, Location, FileName FROM images, tests WHERE (images.ImageID = tests.ImageID)");
				}
				else if($querie==4){
					$sql_array = array("SELECT MAX(Latitude), Username FROM observations WHERE Date < 20110000 GROUP BY Username");
				}
				else if($querie==5){
					$sql_array = array("SELECT AVG(Latitude), Username FROM observations WHERE Date < 20110000 GROUP BY Username HAVING AVG(Longitude) > 0");
				}
				else if($querie==6){
					$sql_array = array("SELECT Location, AVG(Radius), MAX(Radius), FileName, TestID FROM tests, images, objlocations WHERE (images.ImageID = tests.ImageID) AND ( objlocations.ImageID = tests.ImageID ) AND ( tests.ImageID > 10) GROUP BY Location");
				}
				else if($querie==7){
					$sql_array = array("SELECT * FROM images WHERE ImageID NOT IN (SELECT ImageID FROM observations)");
				}
				else if($querie==8){
					$sql_array = array("SELECT * FROM images WHERE Location = '~/images'","UPDATE images SET Location = 'C:/' WHERE Location = '~/images'", "SELECT * FROM images WHERE Location = 'C:/'");
				}
				else if($querie==9){
					$sql_array = array("SELECT * FROM images WHERE Location = 'C:/'","UPDATE images SET Location = '~/images' WHERE Location = 'C:/'","SELECT * FROM images WHERE Location = '~/images'");
				}
				else if($querie==10){
					$sql_array = array("SELECT User FROM mysql.user","CREATE USER 'newuser'@'localhost'","SELECT User FROM mysql.user");
				}
				else if($querie==11){
					$sql_array = array("SELECT User FROM mysql.user","DROP USER 'newuser'@'localhost'","SELECT User FROM mysql.user");
				}
				else if($querie==12){
					$sql_array = array("SELECT * FROM users", "START TRANSACTION", "DELETE FROM users WHERE users.Username NOT IN (SELECT Username FROM observations)", "SELECT * FROM users", "ROLLBACK", "SELECT * FROM users");
				}
				else if($querie==14){
					$sql_array = array ("SELECT TABLE_NAME, COLUMN_NAME, IS_NULLABLE, COLUMN_TYPE, COLUMN_KEY, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME EXTRA FROM information_schema.columns WHERE table_schema = 'test'");
				}
				else if($querie==15){
					$sql_array = array("select TABLE_NAME,COLUMN_NAME,CONSTRAINT_NAME, REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME from INFORMATION_SCHEMA.KEY_COLUMN_USAGE where TABLE_SCHEMA = 'test'");
				}
				else{
					$default_querie_prompt = '';
					$sql_array = array($_POST['sql_command']);
				}


				//$sql_array = array("SHOW TABLES", "SHOW DATABASES", "USE imformation_schema");
				
				/*
				echo "<p> SQL_ARRAY:";
				foreach ($sql_array as $val){
					echo $val.'<br>';
				}
				
				echo "</p>";
				*/
				//$tables_used = array("observations", "images", "objlocations", "validplants", "tests", "users", "testresults", "xmldata");

				$tables_used = array();
				mysql_select_db($dbname, $con);
				$all_tables = mysql_query("SHOW TABLES", $con);

				while($record = mysql_fetch_row($all_tables)){
					array_push($tables_used,"$record[0]");
				}

				foreach ($sql_array as $sql){ 
					$retval = mysql_query($sql, $con);
					if(! $retval )
					{
						die('<p id="bad">Could not update data: '.mysql_error().'.</p>'."<div class='push'></div></div>".'<div class="footer"><p id="cw"> Copyright (c) 2014. Property of Jacob Rail </p></div>');				
					}
					else{
						echo "<p id='good'>Updated data successfully</p><br>";

						echo "<p id='st'> Tables Used: ";
						foreach ($tables_used as $table) {
							//echo $table." ";

							if (strchr($sql, $table)){
								echo $table." ";
							}
						}
						echo "</p>";

						echo "<table id='results' class='center'>";
						echo "<caption>".$default_querie_prompt."<p id='code'>".$sql."</p>"."</caption>";
						// display column names
						$i = 0;
						echo '<tr>';
						while($i < mysql_num_fields($retval)){
							$meta = mysql_fetch_field($retval, $i);
							echo '<th>' . $meta->name . '</th>';
							$i = $i + 1;
						}
						echo '</tr>';
						$i = 0;
						while($record = mysql_fetch_row($retval)){

							if($i >= 2){
								$i = 0;
							}

							if($i == 0){
								echo "<tr>";
							}
							else{
								echo "<tr class='alt'>";
							}
							foreach($record as $key => $value){
								//echo "key(".$key.') ';
								echo "<td> ".$value."</td>";

								//echo $record[$key]. '   ';
							}
							//echo "<br>";
							//echo $record.'<br>';
							$i = $i + 1;
							echo "</tr>";
						}
						echo "</table>";
					}
				}

				mysql_close($conn);
			}
		?>
		<div class="push"></div>
	</div>
	<div class="footer">
		<p id="cw"> Copyright (c) 2014. Property of Jacob Rail </p>
	</div>
	</body>
</html>
