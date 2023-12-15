var System=Java.type("java.lang.System");
var Files=Java.type("java.nio.file.Files");
var File=Java.type("java.io.File");
var Paths=Java.type("java.nio.file.Paths");
var StandardCharsets=Java.type("java.nio.charset.StandardCharsets");
var String=Java.type("java.lang.String");
var charset = StandardCharsets.UTF_8;

var jsDir = new File(System.getenv("DISTRIB_DIR_NAME") + "/nginx/nginx-static/js");
var jsfile;
for (var i = 0 ; i < jsDir.list().length; i++) {
    var filename = jsDir.list()[i];
    if (filename.match(/.*js$/i)) {
        System.out.println("Modifing " + filename);
        jsfile = Paths.get(System.getenv("DISTRIB_DIR_NAME") + "/nginx/nginx-static/js/" + filename);
        break;
    }
};

var content = new String(Files.readAllBytes(jsfile), charset);
//рсхб-страхование жизни (без пробелов)
content = content.replaceAll("\\\\u041e\\\\u041e\\\\u041e \\\\xab\\\\u0420\\\\u0421\\\\u0425\\\\u0411-\\\\u0421\\\\u0442\\\\u0440\\\\u0430\\\\u0445\\\\u043e\\\\u0432\\\\u0430\\\\u043d\\\\u0438\\\\u0435 \\\\u0436\\\\u0438\\\\u0437\\\\u043d\\\\u0438\\\\xbb",
    "\\\\u0410\\\\u041E \\\\u0421\\\\u041A \\\\xab\\\\u0420\\\\u0421\\\\u0425\\\\u0411-\\\\u0421\\\\u0442\\\\u0440\\\\u0430\\\\u0445\\\\u043E\\\\u0432\\\\u0430\\\\u043D\\\\u0438\\\\u0435\\\\xbb");
//рсхб - страхование жизни (с пробелами)
content = content.replaceAll("\\\\u041e\\\\u041e\\\\u041e \\\\xab\\\\u0420\\\\u0421\\\\u0425\\\\u0411 - \\\\u0421\\\\u0442\\\\u0440\\\\u0430\\\\u0445\\\\u043e\\\\u0432\\\\u0430\\\\u043d\\\\u0438\\\\u0435 \\\\u0436\\\\u0438\\\\u0437\\\\u043d\\\\u0438\\\\xbb",
    "\\\\u0410\\\\u041E \\\\u0421\\\\u041A \\\\xab\\\\u0420\\\\u0421\\\\u0425\\\\u0411 - \\\\u0421\\\\u0442\\\\u0440\\\\u0430\\\\u0445\\\\u043E\\\\u0432\\\\u0430\\\\u043D\\\\u0438\\\\u0435\\\\xbb");
//убираем фразу техническая поддержка
content = content.replaceAll("\\\\u0422\\\\u0435\\\\u0445\\\\u043d\\\\u0438\\\\u0447\\\\u0435\\\\u0441\\\\u043a\\\\u0430\\\\u044f \\\\u043f\\\\u043e\\\\u0434\\\\u0434\\\\u0435\\\\u0440\\\\u0436\\\\u043a\\\\u0430: ", "");
content = content.replaceAll("8 \\(800\\) 770 77 88", "8 (800) 700 45 60");
content = content.replaceAll("life@rshb-am.ru", "info@rshbins.ru");
//скрываем email технической поддержки
content = content.replaceAll("foshelp@rshb.life", "");
Files.write(jsfile, content.getBytes(charset));