public void doUpload(String filename)
{
    HttpURLConnection conn = null;
    DataOutputStream os = null;
    DataInputStream inputStream = null;

    String urlServer = "http://216.96.***.***:8000/upload";

    String lineEnd = "\r\n";
    String twoHyphens = "--";
    String boundary =  "*****";
    int bytesRead, bytesAvailable, bufferSize, bytesUploaded = 0;
    byte[] buffer;
    int maxBufferSize = 2*1024*1024;

    String uploadname = filename.substring(23);

    try
    {
        FileInputStream fis = new FileInputStream(new File(filename) );

        URL url = new URL(urlServer);
        conn = (HttpURLConnection) url.openConnection();
        conn.setChunkedStreamingMode(maxBufferSize);

        // POST settings.
        conn.setDoInput(true);
        conn.setDoOutput(true);
        conn.setUseCaches(false);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Connection", "Keep-Alive");
        conn.setRequestProperty("Content-Type", "multipart/form-data; boundary="+boundary);
        conn.addRequestProperty("username", Username);
        conn.addRequestProperty("password", Password);
        conn.connect();

        os = new DataOutputStream(conn.getOutputStream());
        os.writeBytes(twoHyphens + boundary + lineEnd);
        os.writeBytes("Content-Disposition: form-data; name=\"uploadedfile\";filename=\"" + uploadname +"\"" + lineEnd);
        os.writeBytes(lineEnd);

        bytesAvailable = fis.available();
        System.out.println("available: " + String.valueOf(bytesAvailable));
        bufferSize = Math.min(bytesAvailable, maxBufferSize);
        buffer = new byte[bufferSize];

        bytesRead = fis.read(buffer, 0, bufferSize);
        bytesUploaded += bytesRead;
        while (bytesRead > 0)
        {
            os.write(buffer, 0, bufferSize);
            bytesAvailable = fis.available();
            bufferSize = Math.min(bytesAvailable, maxBufferSize);
            buffer = new byte[bufferSize];
            bytesRead = fis.read(buffer, 0, bufferSize);
            bytesUploaded += bytesRead;
        }
        System.out.println("uploaded: "+String.valueOf(bytesUploaded));
        os.writeBytes(lineEnd);
        os.writeBytes(twoHyphens + boundary + twoHyphens + lineEnd);

        // Responses from the server (code and message)
        conn.setConnectTimeout(2000); // allow 2 seconds timeout.
        int rcode = conn.getResponseCode();
        if (rcode == 200) Toast.makeText(getApplicationContext(), "Success!!", Toast.LENGTH_LONG).show();
        else Toast.makeText(getApplicationContext(), "Failed!!", Toast.LENGTH_LONG).show();
        fis.close();
        os.flush();
        os.close();
        Toast.makeText(getApplicationContext(), "Record Uploaded!", Toast.LENGTH_LONG).show();
    }
    catch (Exception ex)
    {
        //ex.printStackTrace();
        //return false;
    }
}
}
