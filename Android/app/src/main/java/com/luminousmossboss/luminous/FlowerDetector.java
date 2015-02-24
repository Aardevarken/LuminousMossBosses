package com.luminousmossboss.luminous;

import org.opencv.core.Mat;
import org.opencv.core.Scalar;

import java.util.List;

import static org.opencv.core.Core.inRange;
import static org.opencv.imgproc.Imgproc.COLOR_BGR2HSV;
import static org.opencv.imgproc.Imgproc.cvtColor;

/**
 * Created by aardevarken on 2/22/15.
 * adapted from detector.cpp and detector.h by Jamie Miller
 */
public class FlowerDetector extends Detector
{
    public FlowerDetector(String flower_xml_name)
    {
        super(flower_xml_name);
    }

    /**
     * Makes all non-pink pixels in an image black.
     */
    public Mat isolatePink(Mat image)
    {
        Mat img_hsv = new Mat();
        Mat mask = new Mat();
        Mat img_filtered = new Mat();
        cvtColor(image, img_hsv, COLOR_BGR2HSV);
        inRange(img_hsv, new Scalar(140, 50, 100), new Scalar(200, 255, 255), mask);
        image.copyTo(img_filtered, mask);
        return  img_filtered;
    }

    /**
     * Detect flowers
     * May miss flowers in corners while rotating image
     */
    public List<Identified> findFlowers(Mat image)
    {
        return null;
    }
}
