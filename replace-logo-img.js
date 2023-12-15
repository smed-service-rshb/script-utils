var System=Java.type("java.lang.System");
var Files=Java.type("java.nio.file.Files");
var Paths=Java.type("java.nio.file.Paths");
var File=Java.type("java.io.File");
var StandardCharsets=Java.type("java.nio.charset.StandardCharsets");
var imgDir = new File(System.getenv("DISTRIB_DIR_NAME") + "/nginx/nginx-static/img");
var logofile;
for (var i = 0 ; i < imgDir.list().length; i++) {
    var filename = imgDir.list()[i];
    if (filename.match(/logo-rshb.*png/i)) {
        System.out.println("Rewrite " + filename);
        logofile = Paths.get(System.getenv("DISTRIB_DIR_NAME") + "/nginx/nginx-static/img/" + filename);
    }
};
var newLogoFile = Paths.get("_settings/logo-rshbins-life.png");
Files.delete(logofile);
Files.copy(newLogoFile, logofile);



