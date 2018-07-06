/*
 * generated by Xtext 2.12.0
 */
package uk.ac.kcl.inf.modelling.xdsml.serializer;

import com.google.inject.Inject;
import java.util.Set;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.xtext.Action;
import org.eclipse.xtext.Parameter;
import org.eclipse.xtext.ParserRule;
import org.eclipse.xtext.serializer.ISerializationContext;
import org.eclipse.xtext.serializer.sequencer.AbstractDelegatingSemanticSequencer;
import uk.ac.kcl.inf.modelling.xdsml.henshinXDsmlSpecification.HenshinXDsmlSpecification;
import uk.ac.kcl.inf.modelling.xdsml.henshinXDsmlSpecification.HenshinXDsmlSpecificationPackage;
import uk.ac.kcl.inf.modelling.xdsml.services.HenshinXDsmlSpecificationGrammarAccess;

@SuppressWarnings("all")
public class HenshinXDsmlSpecificationSemanticSequencer extends AbstractDelegatingSemanticSequencer {

	@Inject
	private HenshinXDsmlSpecificationGrammarAccess grammarAccess;
	
	@Override
	public void sequence(ISerializationContext context, EObject semanticObject) {
		EPackage epackage = semanticObject.eClass().getEPackage();
		ParserRule rule = context.getParserRule();
		Action action = context.getAssignedAction();
		Set<Parameter> parameters = context.getEnabledBooleanParameters();
		if (epackage == HenshinXDsmlSpecificationPackage.eINSTANCE)
			switch (semanticObject.eClass().getClassifierID()) {
			case HenshinXDsmlSpecificationPackage.HENSHIN_XDSML_SPECIFICATION:
				sequence_HenshinXDsmlSpecification(context, (HenshinXDsmlSpecification) semanticObject); 
				return; 
			}
		if (errorAcceptor != null)
			errorAcceptor.accept(diagnosticProvider.createInvalidContextOrTypeDiagnostic(semanticObject, context));
	}
	
	/**
	 * Contexts:
	 *     HenshinXDsmlSpecification returns HenshinXDsmlSpecification
	 *
	 * Constraint:
	 *     units+=[Unit|QualifiedName]+
	 */
	protected void sequence_HenshinXDsmlSpecification(ISerializationContext context, HenshinXDsmlSpecification semanticObject) {
		genericSequencer.createSequence(context, semanticObject);
	}
	
	
}
