<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Database Deletion Utility</title>
    </head>
    <body>
        <?php
            // Function to delete the database
            function deleteDB($dbName, $dbmsServer, $userDB, $passwordDB){
                // Connect to the MySQL server
                $connection = mysqli_connect($dbmsServer, $userDB, $passwordDB);
        
                if($connection){
                    $sql = "DROP DATABASE $dbName;";
                    mysqli_query($connection, $sql);
                    mysqli_close($connection);
                    return true;
                } else{ 
                    return false;
                }
            }
        ?>

        <!-- HTML form for collecting database information -->
        <form action="database_deletion.php" method="post">
            <label>Database Name: </label><input type="text" name="dbName"><br>
            <label>DBMS Server: </label><input type="text" name="dbmsServer"><br>
            <label>MySQL User: </label><input type="text" name="userDB"><br>
            <label>MySQL Password: </label><input type="text" name="passwordDB"><br><br>
            <input type="submit" value="Delete Database" name="deleteDB">
        </form>

        <?php
            // Execute code block if the form has been submitted
            if(isset($_POST["deleteDB"])){
                // Call the deleteDB function with form inputs as arguments
                $result = deleteDB($_POST["dbName"], $_POST["dbmsServer"], $_POST["userDB"], $_POST["passwordDB"]);
            
                // Check the result of database deletion and display appropriate message
                if($result){
                    echo "<p>Database deleted successfully</p>";
                } else{
                    echo "<p>Database connection error</p>";
                }
            }
        ?>
    </body>
</html>
