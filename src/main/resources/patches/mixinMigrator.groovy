package patches
/** In case version 1.0 of cookiePolicy was installed we need to migrated the mixin data to the new one */

import org.jahia.api.Constants
import org.jahia.services.content.*
import org.jahia.services.content.nodetypes.ExtendedNodeType
import org.jahia.services.content.nodetypes.ExtendedPropertyDefinition
import org.jahia.services.content.nodetypes.NodeTypeRegistry

import javax.jcr.NodeIterator
import javax.jcr.RepositoryException
import javax.jcr.query.Query
import javax.jcr.query.QueryResult

def migrateMixinsCB = new JCRCallback<Object>() {

    void migrateMixin(JCRSessionWrapper jcrSession, String sourceNodeType, String destinationNodeType) throws Exception {
        log.info("Start " + sourceNodeType + " mixin to " + destinationNodeType + " mixin in " + jcrSession.getWorkspace().getName() + " workspace");
        NodeTypeRegistry nodeTypeRegistry = NodeTypeRegistry.getInstance();
        ExtendedNodeType cookiePolicyNt = nodeTypeRegistry.getNodeType(sourceNodeType);
        ExtendedPropertyDefinition[] cookiePolicyPropDefs = cookiePolicyNt.getDeclaredPropertyDefinitions()

        QueryResult result = jcrSession.getWorkspace().getQueryManager().createQuery("select * from [" + sourceNodeType + "] as site where isdescendantnode(site, '/sites')", Query.JCR_SQL2).execute();
        NodeIterator ni = result.getNodes();
        while (ni.hasNext()) {
            try {
                JCRNodeWrapper site = (JCRNodeWrapper) ni.next();
                site.addMixin(destinationNodeType);

                for (ExtendedPropertyDefinition cookiePolicyPropDef : cookiePolicyPropDefs) {
                    if (site.hasProperty(cookiePolicyPropDef.getName())) {
                        site.setProperty("cp:" + cookiePolicyPropDef.getName(), site.getProperty(cookiePolicyPropDef.getName()).getValue())
                    }
                }

                site.removeMixin(sourceNodeType)
                jcrSession.save();
                log.info("Site " + site.getName() + ", migrated to " + destinationNodeType + " in " + jcrSession.getWorkspace().getName() + " workspace");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public Object doInJCR(JCRSessionWrapper jcrSession) throws RepositoryException {
        JCRObservationManager.setEventListenersAvailableDuringPublishOnly(true)

        try {
            migrateMixin(jcrSession, "jmix:cookiesPolicy", "cpmix:cookiesPolicy");
            migrateMixin(jcrSession, "jmix:cookiePolicyLink", "cpmix:cookiePolicyLink");
            migrateMixin(jcrSession, "jmix:cookiePolicyExternalLink", "cpmix:cookiePolicyExternalLink");
            migrateMixin(jcrSession, "jmix:cookiePolicyModalMessage", "cpmix:cookiePolicyModalMessage");
        } finally {
            JCRObservationManager.setEventListenersAvailableDuringPublishOnly(false);
        }

        return null;
    }
}


JCRTemplate.getInstance().doExecuteWithSystemSession(migrateMixinsCB);
JCRTemplate.getInstance().doExecuteWithSystemSessionAsUser(null, Constants.LIVE_WORKSPACE, null, migrateMixinsCB)