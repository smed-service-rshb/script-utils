var System=Java.type("java.lang.System");
var Files=Java.type("java.nio.file.Files");
var Paths=Java.type("java.nio.file.Paths");
var StandardCharsets=Java.type("java.nio.charset.StandardCharsets");
var String=Java.type("java.lang.String");
var charset = StandardCharsets.UTF_8;

var domainXml = Paths.get(System.getenv("DISTRIB_DIR_NAME") + "/wildfly/master/domain.xml");
var content = new String(Files.readAllBytes(domainXml), charset);
content = content.replaceAll("\\$DB_HOST", System.getenv("DB_HOST"));
content = content.replaceAll("\\$MAIL_SERVER_HOST", System.getenv("MAIL_SERVER_HOST"));
content = content.replaceAll("\\$MAIL_SERVER_FROM", System.getenv("MAIL_SERVER_FROM"));
content = content.replaceAll("\\$MAIL_SERVER_USERNAME", System.getenv("MAIL_SERVER_USERNAME"));
content = content.replaceAll("\\$MAIL_SERVER_PASSWORD", System.getenv("MAIL_SERVER_PASSWORD"));
content = content.replaceAll("\\$MAIL_SERVER_SMTP_PORT", System.getenv("MAIL_SERVER_SMTP_PORT"));
Files.write(domainXml, content.getBytes(charset));

var masterHostXml = Paths.get(System.getenv("DISTRIB_DIR_NAME") + "/wildfly/master/host.xml");
content = new String(Files.readAllBytes(masterHostXml), charset);
content = content.replaceAll("\\$BACKEND_SERVER_HOST", System.getenv("BACKEND_SERVER_HOST"));
content = content.replaceAll("\\$ES_CLUSTER_NAME", System.getenv("ES_CLUSTER_NAME"));
Files.write(masterHostXml, content.getBytes(charset));

var slaveHostXml = Paths.get(System.getenv("DISTRIB_DIR_NAME") + "/wildfly/slave/host.xml");
content = new String(Files.readAllBytes(slaveHostXml), charset);
content = content.replaceAll("\\$BACKEND_SERVER_HOST_2", System.getenv("BACKEND_SERVER_HOST_2"));
content = content.replaceAll("\\$BACKEND_SERVER_HOST", System.getenv("BACKEND_SERVER_HOST"));
content = content.replaceAll("\\$ES_CLUSTER_NAME", System.getenv("ES_CLUSTER_NAME"));
Files.write(slaveHostXml, content.getBytes(charset));