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
			{!! Form::label('leaf_type', 'Leaf_type:') !!}
			{!! Form::text('leaf_type') !!}
		</li>
		<li>
			{!! Form::label('needle_arragement', 'Needle_arragement:') !!}
			{!! Form::text('needle_arragement') !!}
		</li>
		<li>
			{!! Form::label('needles_per_fascicle', 'Needles_per_fascicle:') !!}
			{!! Form::text('needles_per_fascicle') !!}
		</li>
		<li>
			{!! Form::label('needle_apex', 'Needle_apex:') !!}
			{!! Form::text('needle_apex') !!}
		</li>
		<li>
			{!! Form::label('cone', 'Cone:') !!}
			{!! Form::text('cone') !!}
		</li>
		<li>
			{!! Form::submit() !!}
		</li>
	</ul>
{!! Form::close() !!}