<!DOCTYPE html>
<html>
<head>
<title>Simple Form Page</title>
</head>
<body>

<h1>Simple Form Page</h1>
<h3>Form:</h3>

<?php
$NO_WRITE = 0;
$file = "/srv/nginx/data.txt";
function customError($errno, $errstr) {
  echo "<b>Error:</b> [$errno] $errstr";
  echo "<br>";
}
set_error_handler("customError");
if($_SERVER['REQUEST_METHOD'] == "POST" and isset($_POST['someAction'])) {
    clear();
}
function clear() {
    $file = "/srv/nginx/data.txt";
    $fc = fopen($file, 'w') or die("Unable to open file!");
    fclose($fc);
}
if (isset($_POST['field1'])) {
    $content = $_POST['field1'];
    if (empty($content)) {
        $NO_WRITE = 1;
    }
    if ($NO_WRITE != 1) {
        $fh = fopen($file, 'a');
        fwrite($fh, $content);
        fwrite($fh, "<br>");
        fwrite($fh, "\n");
        fclose($fh);
    }
}
if (filesize($file) > 0) {
    $myfile = fopen($file, "r") or die("Unable to open file!");
    echo fread($myfile,filesize($file));
    fclose($myfile);
}
?>

<form action="index.php" method="POST" autocomplete="off">
    <input name="field1" type="text" autofocus />
    <input type="submit" name="submit" value="Send">
    <input type="submit" name="submit" value="Reload">
    <input type="submit" name="someAction" value="Clear" />
</form>

</body>
</html>
