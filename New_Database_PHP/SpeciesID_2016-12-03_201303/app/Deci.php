<?php

namespace Field Guide;

use Illuminate\Database\Eloquent\Model;

class Deci extends Model {

	protected $table = 'Deciduous';
	public $timestamps = false;

	public function deci_to_wood()
	{
		return $this->hasMany('Wood', 'leaf_type');
	}

}