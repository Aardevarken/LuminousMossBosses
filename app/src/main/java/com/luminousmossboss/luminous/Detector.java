package com.luminousmossboss.luminous;
import org.opencv.objdetect.CascadeClassifier;

/**
 * Created by aardevarken on 2/22/15.
 * adapted from detector.cpp and detector.h by Jamie Miller
 */
public abstract class Detector
{
    private CascadeClassifier classifier;

    public Detector(String xml_name)
    {
        this.classifier = new CascadeClassifier();
        if (!this.classifier.load(xml_name))
        {
            System.out.print("Failed to load classifier with xml: " + xml_name);
            System.exit(-1);
        }
    }





}
