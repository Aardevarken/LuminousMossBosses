<?php

namespace Field Guide;

use Illuminate\Database\Eloquent\Model;

class Gram extends Model {

	protected $table = 'Graminoids';
	public $timestamps = false;

	public function gram_to_specie()
	{
		return $this->hasMany('Snames', 'species_name');
	}

}