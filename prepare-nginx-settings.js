var System=Java.type("java.lang.System");
var Files=Java.type("java.nio.file.Files");
var Paths=Java.type("java.nio.file.Paths");
var StandardCharsets=Java.type("java.nio.charset.StandardCharsets");
var String=Java.type("java.lang.String");

var path = Paths.get(System.getenv("DISTRIB_DIR_NAME") + "/nginx/default.conf");
var charset = StandardCharsets.UTF_8;
var content = new String(Files.readAllBytes(path), charset);

content = content.replaceAll("\\$EFR_BACKEND_BASE_PATH", System.getenv("EFR_BACKEND_BASE_PATH") == null ? "" : System.getenv("EFR_BACKEND_BASE_PATH"));
content = content.replaceAll("\\$EFR_PROXY_BASE_PATH", System.getenv("EFR_PROXY_BASE_PATH") == null ? "" : System.getenv("EFR_PROXY_BASE_PATH"));
content = content.replaceAll("\\$BACKEND_SERVER_HOST_2", System.getenv("BACKEND_SERVER_HOST_2"));
content = content.replaceAll("\\$BACKEND_SERVER_HOST", System.getenv("BACKEND_SERVER_HOST"));
content = content.replaceAll("\\$API_GATEWAY_PORT", System.getenv("API_GATEWAY_PORT"));
content = content.replaceAll("\\$EFR_PRESENTATION_BASE_PATH", System.getenv("EFR_PRESENTATION_BASE_PATH") == null ? "" : System.getenv("EFR_PRESENTATION_BASE_PATH"));
Files.write(path, content.getBytes(charset));