{!! Form::open(array('route' => 'route.name', 'method' => 'POST')) !!}
	<ul>
		<li>
			{!! Form::label('user_name', 'User_name:') !!}
			{!! Form::text('user_name') !!}
		</li>
		<li>
			{!! Form::label('password', 'Password:') !!}
			{!! Form::text('password') !!}
		</li>
		<li>
			{!! Form::label('email', 'Email:') !!}
			{!! Form::text('email') !!}
		</li>
		<li>
			{!! Form::label('is_researcher', 'Is_researcher:') !!}
			{!! Form::text('is_researcher') !!}
		</li>
		<li>
			{!! Form::label('privacy_setting', 'Privacy_setting:') !!}
			{!! Form::text('privacy_setting') !!}
		</li>
		<li>
			{!! Form::label('notification_settings', 'Notification_settings:') !!}
			{!! Form::text('notification_settings') !!}
		</li>
		<li>
			{!! Form::label('signal_strength', 'Signal_strength:') !!}
			{!! Form::text('signal_strength') !!}
		</li>
		<li>
			{!! Form::label('maps_saved', 'Maps_saved:') !!}
			{!! Form::text('maps_saved') !!}
		</li>
		<li>
			{!! Form::submit() !!}
		</li>
	</ul>
{!! Form::close() !!}