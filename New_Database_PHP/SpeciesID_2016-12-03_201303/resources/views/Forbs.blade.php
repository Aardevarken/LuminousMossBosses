{!! Form::open(array('route' => 'route.name', 'method' => 'POST')) !!}
	<ul>
		<li>
			{!! Form::label('species_name', 'Species_name:') !!}
			{!! Form::text('species_name') !!}
		</li>
		<li>
			{!! Form::label('family_name', 'Family_name:') !!}
			{!! Form::text('family_name') !!}
		</li>
		<li>
			{!! Form::label('flower_color', 'Flower_color:') !!}
			{!! Form::text('flower_color') !!}
		</li>
		<li>
			{!! Form::label('inflorescence', 'Inflorescence:') !!}
			{!! Form::text('inflorescence') !!}
		</li>
		<li>
			{!! Form::label('flower_shape', 'Flower_shape:') !!}
			{!! Form::text('flower_shape') !!}
		</li>
		<li>
			{!! Form::label('petal_number', 'Petal_number:') !!}
			{!! Form::text('petal_number') !!}
		</li>
		<li>
			{!! Form::label('leaf_arrangement', 'Leaf_arrangement:') !!}
			{!! Form::text('leaf_arrangement') !!}
		</li>
		<li>
			{!! Form::label('leaf_shape', 'Leaf_shape:') !!}
			{!! Form::text('leaf_shape') !!}
		</li>
		<li>
			{!! Form::label('leaf_shapw_filter', 'Leaf_shapw_filter:') !!}
			{!! Form::text('leaf_shapw_filter') !!}
		</li>
		<li>
			{!! Form::label('habitat', 'Habitat:') !!}
			{!! Form::text('habitat') !!}
		</li>
		<li>
			{!! Form::submit() !!}
		</li>
	</ul>
{!! Form::close() !!}