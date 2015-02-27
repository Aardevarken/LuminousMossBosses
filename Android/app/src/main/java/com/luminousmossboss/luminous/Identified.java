package com.luminousmossboss.luminous;

/**
 * Created by Morgan Garske on 2/22/15.
 * Adapted from identified.h by Brian Bauer
 */
public class Identified {
    private boolean OpenCV; // if it was identified by opencv or human input
    private int x;          // x coordinate
    private int y;          // y coordinate
    private int r;          // radius
    private double glx;     // x coordinate in gl
    private double gly;     // y coordinate in gl
    private double glr;     // radius in gl
    public boolean select;
    public boolean falsePositive; // if it was a false positive

    /*
     * Constructors
     */

    public Identified(boolean state)
    {
        OpenCV = state;
        falsePositive = false;
        select = false;
    }

    public Identified(double x, double y, double r, boolean state, int width, int height, double asp_src)
    {
        if (state)
        {
            this.x = (int)x;
            this.y = (int)y;
            this.r = (int)r;
            glx = convertToGLx(this.x, width, asp_src);
            gly = convertToGLy(this.y, height);
            glr = convertToGLr(this.r, width, height, asp_src);
        }
        else if(!state)
        {
            glx = x;
            gly = y;
            glr = r;
            this.x = convertToCVx(glx, width, asp_src);
            this.y = convertToCVy(gly, height);
            this.r = convertToCVr(glr, width, height, asp_src);
        }
        OpenCV = state;
        falsePositive = false;
        select = false;
    }

    public Identified(double x, double y, double r, double glx, double gly, double glr, boolean state, boolean fp)
    {
        this.x = (int)x;
        this.y = (int)y;
        this.r = (int)r;

        this.glx = glx;
        this.gly = gly;
        this.glr = glr;

        OpenCV = state;
        falsePositive = fp;
        select = false;
    }

    /* put copy constructor here if necessary */


    /*
     * gettters
     */

    public double getGlx()
    {
        return glx;
    }

    public double getGly()
    {
        return gly;
    }

    public double getGlr()
    {
        return glr;
    }

    public int getCVx()
    {
        return x;
    }

    public int getCVy()
    {
        return y;
    }

    public int getCVr()
    {
        return r;
    }

    public boolean byOpenCV()
    {
        return OpenCV;
    }

    public void setGl(double x, double y, double r, int width, int height, double asp_src)
    {
        glx = x;
        gly = y;
        glr = r;
        this.x = convertToCVx(glx, width, asp_src);
        this.y = convertToCVy(y, height);
        this.r = convertToCVr(r, width, height, asp_src);
    }

    public void setGlx(double n, int width, double asp_src)
    {
        glx = n;
        this.x = convertToCVx(glx, width, asp_src);
    }

    public void setGly(double n, int height, double asp_src)
    {
        gly = n;
        this.y = convertToCVy(gly, height);
    }

    public void setGlr(double n, int width, int height, double asp_src)
    {
        glr = n;
        this.r = convertToCVr(glr,width, height, asp_src);
    }

    public void setCV(double x, double y, double r, int width, int height, double asp_src)
    {
        this.x = (int)x;
        this.y = (int)y;
        this.r = (int)r;
        glx = convertToGLx(this.x, width, asp_src);
        gly = convertToGLy(this.y, height);
        glr = convertToGLr(this.r, width, height, asp_src);
    }

    public void setCVx(double n, int width, double asp_src)
    {
        x = (int)n;
        glx = convertToGLx(x, width, asp_src);
    }

    public void setCVy(double n, int height, double asp_src)
    {
        y = (int)n;
        gly = convertToGLy(y, height);
    }

    public void setCVr(double n, int width, int height, double asp_src)
    {
        r = (int)n;
        glr = convertToGLr(r, width, height, asp_src);
    }

    public boolean isEqual(Identified id)
    {
        return (x == id.getCVx() && y == id.getCVy() && r == id.getCVr() &&
                glx == id.getGlx() && gly == id.getGly() && glr == id.getGlr() &&
                OpenCV == id.byOpenCV() && falsePositive == id.falsePositive);
    }

    /*
     * Convert gl coordinates to cv
     */
    private int convertToCVx(double glx, int width, double asp_src)
    {
        return (int)((glx + asp_src) * ((double)width / 2.0 / asp_src));
    }
    private int convertToCVy(double gly, int height)
    {
        return (int)((gly - 1.0) * ((double)height / 2.0));
    }
    private int convertToCVr(double glr, int width, int height, double asp_src)
    {
        return (int)(glr * ((double)width / (double)height) / 4.0 / ((asp_src + 1.0) / 2.0));
    }

    /*
     * Convert cv coordinates to gl
     */
    double convertToGLx(int x, int width, double asp_src)
    {
        return ((double)x / (double)width * (2.0 * asp_src) -  asp_src);
    }
    double convertToGLy(int y, int height)
    {
        return (-(double)y / (double)height * 2.0 + 1.0);
    }

    double convertToGLr(int r, int width, int height, double asp_src)
    {
        return ((double)r / (double)(width + height) * 4.0 * ((asp_src + 1.0 ) / 2.0));
    }
}
