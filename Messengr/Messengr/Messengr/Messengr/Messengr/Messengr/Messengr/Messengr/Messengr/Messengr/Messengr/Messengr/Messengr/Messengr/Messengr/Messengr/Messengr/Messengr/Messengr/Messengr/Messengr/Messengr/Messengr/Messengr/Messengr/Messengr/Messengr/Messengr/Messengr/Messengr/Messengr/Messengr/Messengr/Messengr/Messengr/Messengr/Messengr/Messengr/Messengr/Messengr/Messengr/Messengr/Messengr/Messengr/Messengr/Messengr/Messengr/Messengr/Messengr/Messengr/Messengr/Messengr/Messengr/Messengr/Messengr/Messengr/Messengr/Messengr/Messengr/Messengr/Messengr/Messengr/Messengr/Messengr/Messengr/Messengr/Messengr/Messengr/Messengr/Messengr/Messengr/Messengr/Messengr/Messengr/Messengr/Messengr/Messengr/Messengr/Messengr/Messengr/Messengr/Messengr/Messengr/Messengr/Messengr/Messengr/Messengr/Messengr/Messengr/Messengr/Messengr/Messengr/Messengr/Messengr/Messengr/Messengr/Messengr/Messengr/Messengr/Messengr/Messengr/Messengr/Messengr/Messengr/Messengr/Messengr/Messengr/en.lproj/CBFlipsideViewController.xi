<?xml version="1.0" encoding="UTF-8"?>
<archive type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="8.00">
	<data>
		<int key="IBDocument.SystemTarget">1536</int>
		<string key="IBDocument.SystemVersion">12A269</string>
		<string key="IBDocument.InterfaceBuilderVersion">2835</string>
		<string key="IBDocument.AppKitVersion">1187</string>
		<string key="IBDocument.HIToolboxVersion">624.00</string>
		<object class="NSMutableDictionary" key="IBDocument.PluginVersions">
			<string key="NS.key.0">com.apple.InterfaceBuilder.IBCocoaTouchPlugin</string>
			<string key="NS.object.0">1919</string>
		</object>
		<array key="IBDocument.IntegratedClassDependencies">
			<string>IBNSLayoutConstraint</string>
			<string>IBProxyObject</string>
			<string>IBUIBarButtonItem</string>
			<string>IBUINavigationBar</string>
			<string>IBUINavigationItem</string>
			<string>IBUIView</string>
		</array>
		<array key="IBDocument.PluginDependencies">
			<string>com.apple.InterfaceBuilder.IBCocoaTouchPlugin</string>
		</array>
		<object class="NSMutableDictionary" key="IBDocument.Metadata">
			<string key="NS.key.0">PluginDependencyRecalculationVersion</string>
			<integer value="1" key="NS.object.0"/>
		</object>
		<array class="NSMutableArray" key="IBDocument.RootObjects" id="1000">
			<object class="IBProxyObject" id="372490531">
				<string key="IBProxiedObjectIdentifier">IBFilesOwner</string>
				<string key="targetRuntimeIdentifier">IBCocoaTouchFramework</string>
			</object>
			<object class="IBProxyObject" id="340535442">
				<string key="IBProxiedObjectIdentifier">IBFirstResponder</string>
				<string key="targetRuntimeIdentifier">IBCocoaTouchFramework</string>
			</object>
			<object class="IBUIView" id="249263867">
				<reference key="NSNextResponder"/>
				<int key="NSvFlags">274</int>
				<array class="NSMutableArray" key="NSSubviews">
					<object class="IBUINavigationBar" id="871675769">
						<reference key="NSNextResponder" ref="249263867"/>
						<int key="NSvFlags">290</int>
						<string key="NSFrameSize">{320, 44}</string>
						<reference key="NSSuperview" ref="249263867"/>
						<reference key="NSWindow"/>
						<reference key="NSNextKeyView"/>
						<bool key="IBUIOpaque">NO</bool>
						<bool key="IBUIClearsContextBeforeDrawing">NO</bool>
						<string key="targetRuntimeIdentifier">IBCocoaTouchFramework</string>
						<int key="IBUIBarStyle">1</int>
						<array key="IBUIItems">
							<object class="IBUINavigationItem" id="553200710">
								<reference key="IBUINavigationBar" ref="871675769"/>
								<string key="IBUITitle">Title</string>
								<object class="IBUIBarButtonItem" key="IBUILeftBarButtonItem" id="854562692">
									<string key="targetRuntimeIdentifier">IBCocoaTouchFramework</string>
									<int key="IBUIStyle">1</int>
									<reference key="IBUINavigationItem" ref="553200710"/>
									<int key="IBUISystemItemIdentifier">0</int>
								</object>
								<string key="targetRuntimeIdentifier">IBCocoaTouchFramework</string>
							</object>
						</array>
					</object>
				</array>
				<string key="NSFrame">{{0, 20}, {320, 548}}</string>
				<reference key="NSSuperview"/>
				<reference key="NSWindow"/>
				<reference key="NSNextKeyView" ref="871675769"/>
				<object class="NSColor" key="IBUIBackgroundColor">
					<int key="NSColorSpace">3</int>
					<bytes key="NSWhite">MC4yNQA</bytes>
					<object class="NSColorSpace" key="NSCustomColorSpace">
						<int key="NSID">2</int>
					</object>
				</object>
				<bool key="IBUIClearsContextBeforeDrawing">NO</bool>
				<object class="IBUISimulatedStatusBarMetrics" key="IBUISimulatedStatusBarMetrics">
					<int key="IBUIStatusBarStyle">2</int>
				</object>
				<object class="IBUIScreenMetrics" key="IBUISimulatedDestinationMetrics">
					<string key="IBUISimulatedSizeMetricsClass">IBUIScreenMetrics</string>
					<object class="NSMutableDictionary" key="IBUINormalizedOrientationToSizeMap">
						<bool key="EncodedWithXMLCoder">YES</bool>
						<array key="dict.sortedKeys">
							<integer value="1"/>
							<integer value="3"/>
						</array>
						<array key="dict.values">
							<string>{320, 568}</string>
							<string>{568, 320}</string>
						</array>
					</object>
					<string key="IBUITargetRuntime">IBCocoaTouchFramework</string>
					<string key="IBUIDisplayName">Retina 4 Full Screen</string>
					<int key="IBUIType">2</int>
				</object>
				<string key="targetRuntimeIdentifier">IBCocoaTouchFramework</string>
			</object>
		</array>
		<object class="IBObjectContainer" key="IBDocument.Objects">
			<array class="NSMutableArray" key="connectionRecords">
				<object class="IBConnectionRecord">
					<object class="IBCocoaTouchOutletConnection" key="connection">
						<string key="label">view</string>
						<reference key="source" ref="372490531"/>
						<reference key="destination" ref="249263867"/>
					</object>
					<int key="connectionID">41</int>
				</object>
				<object class="IBConnectionRecord">
					<object class="IBCocoaTouchEventConnection" key="connection">
						<string key="label">done:</string>
						<reference key="source" ref="854562692"/>
						<reference key="destination" ref="372490531"/>
					</object>
					<int key="connectionID">46</int>
				</object>
			</array>
			<object class="IBMutableOrderedSet" key="objectRecords">
				<array key="orderedObjects">
					<object class="IBObjectRecord">
						<int key="objectID">0</int>
						<array key="object" id="0"/>
						<reference key="children" ref="1000"/>
						<nil key="parent"/>
					</object>
					<object class="IBObjectRecord">
						<int key="objectID">-1</int>
						<reference key="object" ref="372490531"/>
						<reference key="parent" ref="0"/>
						<string key="objectName">File's Owner</string>
					</object>
					<object class="IBObjectRecord">
						<int key="objectID">-2</int>
						<reference key="object" ref="340535442"/>
						<reference key="parent" ref="0"/>
					</object>
					<object class="IBObjectRecord">
						<int key="objectID">40</int>
						<reference key="object" ref="249263867"/>
						<array class="NSMutableArray" key="children">
							<reference ref="871675769"/>
							<object class="IBNSLayoutConstraint" id="591162250">
								<reference key="firstItem" ref="871675769"/>
								<int key="firstAttribute">6</int>
								<int key="relation">0</int>
								<reference key="secondItem" ref="249263867"/>
								<int key="secondAttribute">6</int>
								<float key="multiplier">1</float>
								<object class="IBLayoutConstant" key="constant">
									<double key="value">0.0</double>
								</object>
								<float key="priority">1000</float>
								<reference key="containingView" ref="249263867"/>
								<int key="scoringType">8</int>
								<float key="scoringTypeFloat">29</float>
								<int key="contentType">3</int>
							</object>
							<object class="IBNSLayoutConstraint" id="64945523">
								<reference key="firstItem" ref="871675769"/>
								<int key="firstAttribute">3</int>
								<int key="relation">0</int>
								<reference key="secondItem" ref="249263867"/>
								<int key="secondAttribute">3</int>
								<float key="multiplier">1</float>
								<object class="IBLayoutConstant" key="constant">
									<double key="value">0.0</double>
								</object>
								<float key="priority">1000</float>
								<reference key="containingView" ref="249263867"/>
								<int key="scoringType">8</int>
								<float key="scoringTypeFloat">29</float>
								<int key="contentType">3</int>
							</object>
							<object class="IBNSLayoutConstraint" id="927769008">
								<reference key="firstItem" ref="871675769"/>
								<int key="firstAttribute">5</int>
								<int key="relation">0</int>
								<reference key="secondItem" ref="249263867"/>
								<int key="secondAttribute">5</int>
								<float key="multiplier">1</float>
								<object class="IBLayoutConstant" key="constant">
									<double key="value">0.0</double>
								</object>
								<float key="priority">1000</float>
								<reference key="containingView" ref="249263867"/>
								<int key="scoringType">8</int>
								<float key="scoringTypeFloat">29</float>
								<int key="contentType">3</int>
							</object>
						</array>
						<reference key="parent" ref="0"/>
					</object>
					<object class="IBObjectRecord">
						<int key="objectID">42</int>
						<reference key="object" ref="871675769"/>
						<array class="NSMutableArray" key="children">
							<reference ref="553200710"/>
						</array>
						<reference key="parent" ref="249263867"/>
					</object>
					<object class="IBObjectRecord">
						<int key="objectID">43</int>
						<reference key="object" ref="553200710"/>
						<array class="NSMutableArray" key="children">
							<reference ref="854562692"/>
						</array>
						<reference key="parent" ref="871675769"/>
					</object>
					<object class="IBObjectRecord">
						<int key="objectID">44</int>
						<reference key="object" ref="854562692"/>
						<reference key="parent" ref="553200710"/>
					</object>
					<object class="IBObjectRecord">
						<int key="objectID">47</int>
						<reference key="object" ref="927769008"/>
						<reference key="parent" ref="249263867"/>
					</object>
					<object class="IBObjectRecord">
						<int key="objectID">48</int>
						<reference key="object" ref="64945523"/>
						<reference key="parent" ref="249263867"/>
					</object>
					<object class="IBObjectRecord">
						<int key="objectID">49</int>
						<reference key="object" ref="591162250"/>
						<reference key="parent" ref="249263867"/>
					</object>
				</array>
			</object>
			<dictionary class="NSMutableDictionary" key="flattenedProperties">
				<string key="-1.CustomClassName">CBFlipsideViewController</string>
				<string key="-1.IBPluginDependency">com.apple.InterfaceBuilder.IBCocoaTouchPlugin</string>
				<string key="-2.CustomClassName">UIResponder</string>
				<string key="-2.IBPluginDependency">com.apple.InterfaceBuilder.IBCocoaTouchPlugin</string>
				<string key="40.IBPluginDependency">com.apple.InterfaceBuilder.IBCocoaTouchPlugin</string>
				<array key="40.IBViewMetadataConstraints">
					<reference ref="927769008"/>
					<reference ref="64945523"/>
					<reference ref="591162250"/>
				</array>
				<string key="42.IBPluginDependency">com.apple.InterfaceBuilder.IBCocoaTouchPlugin</string>
				<boolean value="NO" key="42.IBViewMetadataTranslatesAutoresizingMaskIntoConstraints"/>
				<string key="43.IBPluginDependency">com.apple.InterfaceBuilder.IBCocoaTouchPlugin</string>
				<string key="44.IBPluginDependency">com.apple.InterfaceBuilder.IBCocoaTouchPlugin</string>
				<string key="47.IBPluginDependency">com.apple.InterfaceBuilder.IBCocoaTouchPlugin</string>
				<string key="48.IBPluginDependency">com.apple.InterfaceBuilder.IBCocoaTouchPlugin</string>
				<string key="49.IBPluginDependency">com.apple.InterfaceBuilder.IBCocoaTouchPlugin</string>
			</dictionary>
			<dictionary class="NSMutableDictionary" key="unlocalizedProperties"/>
			<nil key="activeLocalization"/>
			<dictionary class="NSMutableDictionary" key="localizations"/>
			<nil key="sourceID"/>
			<int key="maxID">49</int>
		</object>
		<object class="IBClassDescriber" key="IBDocument.Classes"/>
		<int key="IBDocument.localizationMode">0</int>
		<string key="IBDocument.TargetRuntimeIdentifier">IBCocoaTouchFramework</string>
		<bool key="IBDocument.PluginDeclaredDependenciesTrackSystemTargetVersion">YES</bool>
		<int key="IBDocument.defaultPropertyAccessControl">3</int>
		<bool key="IBDocument.UseAutolayout">YES</bool>
		<string key="IBCocoaTouchPluginVersion">1919</string>
	</data>
</archive>
