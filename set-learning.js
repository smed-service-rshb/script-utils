var System=Java.type("java.lang.System");
var Files=Java.type("java.nio.file.Files");
var File=Java.type("java.io.File");
var Paths=Java.type("java.nio.file.Paths");
var StandardCharsets=Java.type("java.nio.charset.StandardCharsets");
var String=Java.type("java.lang.String");
var charset = StandardCharsets.UTF_8;



var indexPageFile = Paths.get(System.getenv("DISTRIB_DIR_NAME") + "/nginx/nginx-static/index.html");
System.out.println("Set global variable \"learning\"");
content = new String(Files.readAllBytes(indexPageFile), charset);
content = content.replace("<script type=\"text/javascript\">", "<script type=\"text/javascript\"> document.learning=true;");
Files.write(indexPageFile, content.getBytes(charset));

var indexCustomersPageFile = Paths.get(System.getenv("DISTRIB_DIR_NAME") + "/nginx/nginx-static-customers/index.html");
System.out.println("Set global variable \"learning\"");
content = new String(Files.readAllBytes(indexCustomersPageFile), charset);
content = content.replace("<script type=\"text/javascript\">", "<script type=\"text/javascript\"> document.learning=true;");
Files.write(indexCustomersPageFile, content.getBytes(charset));
