<?php

namespace Field Guide;

use Illuminate\Database\Eloquent\Model;

class Need extends Model {

	protected $table = 'Needle';
	public $timestamps = false;

	public function needle_to_wood()
	{
		return $this->hasMany('Wood', 'leaf_type');
	}

}