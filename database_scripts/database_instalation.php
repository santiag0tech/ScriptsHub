<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Database Generation Utility</title>
    </head>
    <body>
        <?php
            // Function to create the DB 
            function createDB($dbName, $dbmsServer, $userDB, $passwordDB){
                $connection = mysqli_connect($dbmsServer, $userDB, $passwordDB);
        
                if($connection){
                    $sql = "CREATE DATABASE IF NOT EXISTS $dbName;";
                    mysqli_query($connection, $sql);
                    mysqli_close($connection);
                    return true;
                } else{ 
                    return false;
                }
            }
        ?>

        <!-- HTML form for collecting database information -->
        <form action="database_instalation.php" method="post">
            <label>Database Name: </label><input type="text" name="dbName"><br>
            <label>DBMS Server: </label><input type="text" name="dbmsServer"><br>
            <label>MySQL User: </label><input type="text" name="userDB"><br>
            <label>MySQL Password: </label><input type="text" name="passwordDB"><br><br>
            <input type="submit" value="Create Database" name="createDB">
        </form>

        <?php
            // Execute code block if the form has been submitted
            if(isset($_POST["createDB"])){
                // Call the createDB function with form inputs as arguments
                $result = createDB($_POST["dbName"], $_POST["dbmsServer"], $_POST["userDB"], $_POST["passwordDB"]);
            
                // Check the result of database creation and display appropriate message
                if($result){
                    echo "<p>Database created successfully</p>";
                } else{
                    echo "<p>Database connection error</p>";
                }
            }
        ?>
    </body>
</html>
