package com.luminousmossboss.luminous;

import org.opencv.core.Mat;
import org.opencv.core.MatOfRect;
import org.opencv.core.Point;
import org.opencv.core.Scalar;

import java.util.ArrayList;

import static org.opencv.core.Core.circle;
import static org.opencv.core.Core.inRange;
import static org.opencv.imgproc.Imgproc.COLOR_BGR2GRAY;
import static org.opencv.imgproc.Imgproc.COLOR_BGR2HSV;
import static org.opencv.imgproc.Imgproc.cvtColor;
import static org.opencv.imgproc.Imgproc.equalizeHist;
import static org.opencv.imgproc.Imgproc.getRotationMatrix2D;
import static org.opencv.imgproc.Imgproc.warpAffine;

/**
 * Created by Morgan Garske on 2/22/15.
 * adapted from detector.cpp and detector.h by Jamie Miller
 */
public class SileneAcaulisDetector extends Detector
{
    public SileneAcaulisDetector(String flower_xml_name)
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
    public ArrayList<Identified> findFlowers(Mat image)
    {
        //Parameters
        final int increment = 40; //for image rotation

        //Initialize variables
        ArrayList<Identified> found = new ArrayList<>();
        Mat rotated = new Mat();
        Mat temp;
        Mat rotated_gray = new Mat();
        double asp_src = image.size().width/image.size().height;
        double centerx = image.cols()/2.0;
        double centery = image.rows()/2.0;
        Point center = new Point(centerx, centery); // point used here instead of Point2f. double instead of float

        for (int theta = 0; theta < 360; theta+=increment) {
            //rotate image
            temp = getRotationMatrix2D(center, -(double)theta, 1.0);
            warpAffine(image, rotated, temp, image.size());

            //convert to grayscale
            cvtColor(rotated, rotated_gray, COLOR_BGR2GRAY);
            equalizeHist(rotated_gray, rotated_gray);

            //run detection
            MatOfRect flowers = new MatOfRect();
            this.getClassifier().detectMultiScale(rotated_gray, flowers);

            //Convert detections to nonrotated coordinates
            for (int i = 0; i < flowers.toList().size(); i++) {
                double rotated_locationx = flowers.toList().get(i).x + flowers.toList().get(i).width*0.5;
                double rotated_locationy = flowers.toList().get(i).y + flowers.toList().get(i).height*0.5;
                double dx = rotated_locationx - centerx;
                double dy = rotated_locationy - centery;
                double alpha = theta * Math.PI/180.0;
                double beta = Math.atan2(dy, dx);
                double distance = Math.sqrt(dx * dx + dy * dy);

                //checks if flower was already found
                int radius = (int)Math.max(flowers.toList().get(i).width*0.5, flowers.toList().get(i).height*0.5);
                Point location = new Point(centerx + distance * Math.cos(beta - alpha),
                                           centery + distance * Math.sin(beta - alpha));
                boolean inlist = false;
                if (!found.isEmpty())
                {
                    for (int j = 0; j < found.size(); j++) {
                        if (radius/2 >= Math.abs( location.x - found.get(j).getCVx() )  &&
                            radius/2 >= Math.abs( location.y - found.get(j).getCVy() ))
                        {
                            inlist = true;
                            break;
                        }
                    }
                }
                if (!inlist)
                {
                    Identified tempid = new Identified(location.x, location.y, radius, true, image.cols(), image.rows(), asp_src);
                    found.add(tempid);
                }
            }

        }
        return found;
    }

    /**
     * Takes an image and returns the same image with pink flowers circled in yellow
     */
    public Mat circlePinkFlowers(Mat image)
    {
        Scalar color = new Scalar(255,255,31);
        Mat circledImage = image;
        Mat pink = isolatePink(image);
        ArrayList<Identified> flower = findFlowers(pink);
        for (int i=0; i < flower.size(); i++) {
            circle(circledImage, new Point(flower.get(i).getCVx(), flower.get(i).getCVy()), flower.get(i).getCVr(), color, 8);
        }
        return circledImage;
    }

    public boolean isThisSilene(Mat image)
    {
        Mat pink = isolatePink(image);
        ArrayList<Identified> flowers = findFlowers(pink);
        return flowers.size() >= 1;
    }
}
