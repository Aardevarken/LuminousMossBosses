<?php

namespace GPS Observations;

use Illuminate\Database\Eloquent\Model;

class Snames extends Model {

	protected $table = 'Species_names';
	public $timestamps = false;

	public function sname_to_obs()
	{
		return $this->hasMany('Obs', 'species_name');
	}

	public function forbs_to_specie()
	{
		return $this->hasMany('Snames', 'species_name');
	}

}