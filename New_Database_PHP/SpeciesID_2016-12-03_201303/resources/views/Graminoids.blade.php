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
			{!! Form::label('stem_cross_section', 'Stem_cross_section:') !!}
			{!! Form::text('stem_cross_section') !!}
		</li>
		<li>
			{!! Form::label('growth_form', 'Growth_form:') !!}
			{!! Form::text('growth_form') !!}
		</li>
		<li>
			{!! Form::label('leaf_sheath', 'Leaf_sheath:') !!}
			{!! Form::text('leaf_sheath') !!}
		</li>
		<li>
			{!! Form::label('leaf_blade', 'Leaf_blade:') !!}
			{!! Form::text('leaf_blade') !!}
		</li>
		<li>
			{!! Form::label('ligule', 'Ligule:') !!}
			{!! Form::text('ligule') !!}
		</li>
		<li>
			{!! Form::label('subtrending_bract', 'Subtrending_bract:') !!}
			{!! Form::text('subtrending_bract') !!}
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