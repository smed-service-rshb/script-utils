var System=Java.type("java.lang.System");
var Files=Java.type("java.nio.file.Files");
var Paths=Java.type("java.nio.file.Paths");
var StandardCharsets=Java.type("java.nio.charset.StandardCharsets");
var String=Java.type("java.lang.String");

var path = Paths.get(System.getenv("DISTRIB_DIR_NAME") + "/nginx/nginx-static/index.html");
var charset = StandardCharsets.UTF_8;
var content = new String(Files.readAllBytes(path), charset);

content = content.replaceAll("\"%EFR_BACKEND_PROTOCOL%\"", "window.location.protocol.substr(0,window.location.protocol.length-1)");
content = content.replaceAll("\"%EFR_BACKEND_HOST%\"", "window.location.hostname");
content = content.replaceAll("%EFR_BACKEND_PORT%", "window.location.port");
content = content.replaceAll("%EFR_BACKEND_BASE_PATH%", "/efrapi");
content = content.replaceAll("%EFR_BACKEND_TIMEOUT%", "50000");
Files.write(path, content.getBytes(charset));