var System=Java.type("java.lang.System");
var Files=Java.type("java.nio.file.Files");
var File=Java.type("java.io.File");
var Paths=Java.type("java.nio.file.Paths");
var StandardCharsets=Java.type("java.nio.charset.StandardCharsets");
var String=Java.type("java.lang.String");
var charset = StandardCharsets.UTF_8;

var jsDir = new File(System.getenv("DISTRIB_DIR_NAME") + "/nginx/nginx-static/js")
var jsfile;
for (var i = 0 ; i < jsDir.list().length; i++) {
    var filename = jsDir.list()[i];
    if (filename.match(/.*js$/i)) {
        System.out.println("Replace PROD app title. Modifing " + filename);
        jsfile = Paths.get(System.getenv("DISTRIB_DIR_NAME") + "/nginx/nginx-static/js/" + filename);
        break;
    }
};

var content = new String(Files.readAllBytes(jsfile), charset);
content = content.replace("Учебная среда", "");
Files.write(jsfile, content.getBytes(charset));

var startPageFile = Paths.get(System.getenv("DISTRIB_DIR_NAME") + "/nginx/nginx-static/start.html");
System.out.println("Replace PROD app title. Modifing " + System.getenv("DISTRIB_DIR_NAME") + "/nginx/nginx-static/start.html");
content = new String(Files.readAllBytes(startPageFile), charset);
content = content.replace("Учебная среда", "");
Files.write(startPageFile, content.getBytes(charset));
