{% for firstName, firstData in dirs %}
	<li>
		<span directory="{{firstName}}"{% if currentdir == firstName %} class="active"{% endif %}>{{firstName|decodedirsfiles}}</span>
		{% if firstData %}
			<ul>
				{% for secondName, secondData in firstData %}
					<li>
						<span directory="{{firstName}}/{{secondName}}"{% if currentdir == firstName~'/'~secondName %} class="active"{% endif %}>{{secondName|decodedirsfiles}}</span>
						{% if secondData %}
							<ul>
								{% for thirdName, thirdData in secondData %}
									<li>
										<span directory="{{firstName}}/{{secondName}}/{{thirdName}}"{% if currentdir == firstName~'/'~secondName~'/'~thirdName %} class="active"{% endif %}>{{thirdName|decodedirsfiles}}</span>
										{% if thirdData %}
											<ul>
												{% for forthName, forthData in thirdData %}
													<li>
														<span directory="{{firstName}}/{{secondName}}/{{thirdName}}/{{forthName}}"{% if currentdir == firstName~'/'~secondName~'/'~thirdName~'/'~forthName %} class="active"{% endif %}>{{forthName|decodedirsfiles}}</span>
													</li>
												{% endfor %}
											</ul>
										{% endif %}
									</li>
								{% endfor %}
							</ul>	
						{% endif %}
					</li>
				{% endfor %}
			</ul>
		{% endif %}
	</li>
{% endfor %}