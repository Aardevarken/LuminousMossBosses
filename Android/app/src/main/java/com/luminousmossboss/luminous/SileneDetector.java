package com.luminousmossboss.luminous;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

//import org.opencv.objdetect.CascadeClassifier;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;

/**
 * Created by Morgan Garske on 3/17/15
 */
public class SileneDetector
{

    static { System.loadLibrary("detect_silene"); }
    private String flower_xml;
    private String vocab_xml;
    private String silene_xml;

    public SileneDetector(String flower_xml, String vocab_xml, String silene_xml)
    {
        this.flower_xml = flower_xml;
        this.vocab_xml = vocab_xml;
        this.silene_xml = silene_xml;
    }


    public boolean isSilene(String image_path) {
        Bitmap bitmapImage = BitmapFactory.decodeFile(image_path);
        byte [] photoByteArray;
        ByteArrayOutputStream byte_os = new ByteArrayOutputStream();
        bitmapImage.compress(Bitmap.CompressFormat.JPEG, 0, byte_os);
        photoByteArray = byte_os.toByteArray();
        int height = bitmapImage.getHeight();
        int width = bitmapImage.getWidth();
        return this.isSilene(flower_xml, vocab_xml, silene_xml, height, width, photoByteArray);
    }

    private native boolean isSilene(String flower_xml, String vocab_xml, String silene_xml, int height, int width, byte [] img_array);

}
