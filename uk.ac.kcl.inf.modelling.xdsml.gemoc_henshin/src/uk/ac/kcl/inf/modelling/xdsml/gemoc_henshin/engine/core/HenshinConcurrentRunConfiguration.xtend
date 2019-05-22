package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import java.util.List
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.gemoc.execution.concurrent.ccsljavaengine.commons.ConcurrentRunConfiguration
import uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.solvers.heuristics.HeuristicsRegistry
import org.eclipse.xtend.lib.annotations.Accessors

class HenshinConcurrentRunConfiguration extends ConcurrentRunConfiguration {
	
	new(ILaunchConfiguration launchConfiguration) throws CoreException {
		super(launchConfiguration)
	}
	
	@Accessors(PUBLIC_GETTER)
	var List<HeuristicsRegistry.HeuristicDefinition> heuristics
		
	override extractInformation() {
		super.extractInformation
		
		// TODO Encode heuristics parameters in run configuration and extract them here so they can be stored in a copy of the heuristics description 
		heuristics = _launchConfiguration.getAttribute(HeuristicsRegistry.HEURISTICS_CONFIG_KEY, #[]).map[hdi | HeuristicsRegistry.INSTANCE.get(hdi)].toList
	}
}
