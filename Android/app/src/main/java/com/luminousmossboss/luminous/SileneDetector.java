package com.luminousmossboss.luminous;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

//import org.opencv.objdetect.CascadeClassifier;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;

/**
 * Created by Morgan Garske on 2/22/15.
 * adapted from detector.cpp and detector.h by Jamie Miller
 */
public class SileneDetector
{

    static { System.loadLibrary("detect_silene"); }
    //    private CascadeClassifier cascadeClassifier;
    private String flower_xml;
    private String vocab_xml;
    private String silene_xml;

    public SileneDetector(String flower_xml, String vocab_xml, String silene_xml)
    {
//        this.cascadeClassifier = new CascadeClassifier();
//        if (!this.cascadeClassifier.load(xml_name))
//        {
//            System.out.print("Failed to load cascadeClassifier with xml: " + xml_name);
//            System.exit(-1);
//        }
        this.flower_xml = flower_xml;
        this.vocab_xml = vocab_xml;
        this.silene_xml = silene_xml;
    }


    public boolean isSilene(String image_path) {
        Bitmap bitmapImage = BitmapFactory.decodeFile(image_path);
        int [] mPhotoIntArray;

//        ByteArrayOutputStream stream = new ByteArrayOutputStream();
//        bmp.compress(Bitmap.CompressFormat.PNG, 100, stream);
//        byte[] byteArray = stream.toByteArray();

        Log.w("isSilene", "height: " + Integer.toString(bitmapImage.getHeight()) + ", width: " + Integer.toString(bitmapImage.getWidth()));
//        mPhotoIntArray = new int[bitmapImage.getWidth() * bitmapImage.getHeight()];
        int size = bitmapImage.getWidth() * bitmapImage.getHeight();
//        ByteBuffer b = ByteBuffer.allocate(size);
//        bitmapImage.copyPixelsToBuffer(b);
//        b.rewind();
        byte [] photoByteArray;
        ByteArrayOutputStream byte_os = new ByteArrayOutputStream();
        if (bitmapImage.compress(Bitmap.CompressFormat.JPEG, 0, byte_os)) {
            Log.w("isSilne", "compression successful");
        }
        else
        {
            Log.w("isSilne", "compression unsuccessful");
        }
        photoByteArray = byte_os.toByteArray();
        Log.w("isSilene", "height: " + Integer.toString(bitmapImage.getHeight()) + ", width: " + Integer.toString(bitmapImage.getWidth()));
//        byte [] photoByteArray = new byte [size];
//        b.get(photoByteArray, 0, photoByteArray.length);
//        bitmapImage.getPixels(mPhotoIntArray, 0, bitmapImage.getWidth(), 0, 0, bitmapImage.getWidth(), bitmapImage.getHeight());
//        return this.isSilene(flower_xml, vocab_xml, silene_xml, bitmapImage.getHeight(), bitmapImage.getWidth(), mPhotoIntArray);
        Log.w("isSilene", Integer.toString(photoByteArray[512]));
        return this.isSilene(flower_xml, vocab_xml, silene_xml, bitmapImage.getHeight(), bitmapImage.getWidth(), photoByteArray);
//        return  true;
    }

    private native boolean isSilene(String flower_xml, String vocab_xml, String silene_xml, int height, int width, byte [] img_array);

//    public CascadeClassifier getCascadeClassifier() {
//        return cascadeClassifier;
//    }


}
