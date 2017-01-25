<?php

namespace Field Guide;

use Illuminate\Database\Eloquent\Model;

class Famname extends Model {

	protected $table = 'Family_Name_Filter';
	public $timestamps = false;

	public function famname_to_specie()
	{
		return $this->hasMany('Acc', 'species_name');
	}

}