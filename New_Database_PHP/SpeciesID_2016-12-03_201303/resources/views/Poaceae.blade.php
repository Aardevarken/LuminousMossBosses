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
			{!! Form::label('inflorescence', 'Inflorescence:') !!}
			{!! Form::text('inflorescence') !!}
		</li>
		<li>
			{!! Form::label('florets_per_spikelet', 'Florets_per_spikelet:') !!}
			{!! Form::text('florets_per_spikelet') !!}
		</li>
		<li>
			{!! Form::label('awns', 'Awns:') !!}
			{!! Form::text('awns') !!}
		</li>
		<li>
			{!! Form::label('lemma_apex', 'Lemma_apex:') !!}
			{!! Form::text('lemma_apex') !!}
		</li>
		<li>
			{!! Form::submit() !!}
		</li>
	</ul>
{!! Form::close() !!}