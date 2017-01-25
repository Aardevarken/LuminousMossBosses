<?php 

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the Closure to execute when that URI is requested.
|
*/

Route::get('/', function()
{
	return View::make('hello');
});


Route::resource('acc', 'AccController');
Route::resource('obs', 'ObsController');
Route::resource('snames', 'SnamesController');
Route::resource('fbs', 'FbsController');
Route::resource('famname', 'FamnameController');
Route::resource('gram', 'GramController');
Route::resource('need', 'NeedController');
Route::resource('deci', 'DeciController');
Route::resource('poa', 'PoaController');
Route::resource('cyper', 'CyperController');
Route::resource('jun', 'JunController');
Route::resource('wood', 'WoodController');
