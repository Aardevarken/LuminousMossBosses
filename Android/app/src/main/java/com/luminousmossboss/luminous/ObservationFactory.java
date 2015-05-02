package com.luminousmossboss.luminous;

import android.content.Context;

import com.luminousmossboss.luminous.model.Observation;

import java.util.HashMap;

/**
 * Created by andrey on 4/22/15.
 */
public class ObservationFactory {
    private static final HashMap<Integer, Observation> observations= new HashMap< Integer,Observation>();
    public static Observation getObservation(Integer id, Context context)
    {
        Observation observation;
        if (observations.get(id) == null)
        {
            observation = new Observation(id,context);
            observations.put(id, observation);
        }
        else
        {
            observation = observations.get(id);
        }
        return observation;
    }
    public static void removeObservation(Integer id)
    {
        if(observations.get(id) != null)
        {
            observations.remove(id);
        }

    }
}
