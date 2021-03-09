package uk.ac.kcl.inf.modelling.xdsml.gemoc_henshin.engine.core

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.henshin.interpreter.Match
import org.eclipse.gemoc.trace.commons.model.generictrace.impl.GenericSmallStepImpl
import org.eclipse.gemoc.trace.commons.model.trace.TraceFactory
import org.eclipse.gemoc.trace.commons.model.trace.TracePackage
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * A class representing one possible step of execution in the Henshin Engine.
 * The HenshinSteps are given to the Logical Step Decider to decide which one should be executed next.
 * Each step stores a Henshin rule match which we can execute on a model at a given point of execution.
 * So basically a new Henshin Step is created for each possible rule match we can execute on the model.
 */
class HenshinStep extends GenericSmallStepImpl {

	@Accessors(PUBLIC_GETTER)
	protected Match match

	/**
	 * create a new HenshinStep with a match
	 * @param match
	 */
	new(Match match) {
		super()
		this.match = match

		footprint = TraceFactory.eINSTANCE.createFootprint => [
			val rule = match.rule
			val accessedNodes = rule.lhs.nodes

			// TODO: Should probably include edges, too.
			accesses += accessedNodes.map[n|match.getNodeTarget(n)]

			val changedNodes = accessedNodes.filter [ n |
				val image = rule.mappings.getImage(n, rule.rhs)
				// TODO: Should consider edge changes, too.
				(image === null) || (image.attributes.exists[a|rule.mappings.getOrigin(a).value != a.value])
			]
			// TODO: Should probably include edges, too.
			changes += changedNodes.map[n|match.getNodeTarget(n)]

			val newNodes = rule.rhs.nodes.filter[n|rule.mappings.getOrigin(n) === null]
			instantiations += newNodes.map[type]
		]
	}

	/**
	 * return a MSEOccurence for a step, MSEOccurences represent objects that we run updates on 
	 * so in case of Henshin it's a set of objects(element nodes). MSEOccurences are used by GEMOC
	 * to track changes to let the addons(such as animator) know when they should be updated so 
	 * without defining them the Sirius animator will never update.
	 * MSEOcurrences are also used for display purposes in the Logical Step Decider therefore they have been
	 * mocked in this method to show a  more meaningful representation to the user.
	 */
	override getMseoccurrence() {
		generateMSE(match, match.getRule().getName(), match.toString())
	}

	/**
	 * mock the generation of MSEOccurences
	 * simulate creating MSE object -> with operation name same as rule name
	 * concat the rule names for display purposes of the concurrent steps
	 * @param a match, string of the rule/s name/s and string of all matched objects or again rule names
	 */
	// TODO: Should rethink how we're generating / reusing MSEs
	// TODO: Should rethink whether we need to make all node targets into parameters, now that these are documented via the footprint
	def generateMSE(Match match, String name, String name2) {
		val mse = TracePackage::eINSTANCE.traceFactory.createGenericMSE()
		mse.setCallerReference(match.mainObject)
		val eo = EcoreFactory.eINSTANCE.createEOperation()
		eo.setName(name)
		mse.setActionReference(eo);
		mse.setName(name2)

		val mseoc = TracePackage::eINSTANCE.traceFactory.createMSEOccurrence()
		mseoc.setMse(mse)
		for (EObject e : match.getNodeTargets()) {
			mseoc.parameters.add(e)
		}
		mseoc
	}

	/**
	 * extract a node from a match with a Target annotation (one per rule is expected)
	 * if for some reason, more than one exists then pick a random one out of them.
	 * @param match
	 */
	private def mainObject(Match match) {
		val targetNode = match.rule.lhs.nodes.findFirst [ n |
			n.annotations.exists[a|a.key == "Target"]
		]

		if (targetNode !== null) {
			match.getNodeTarget(targetNode)
		} else {
			null
		}
	}
}
