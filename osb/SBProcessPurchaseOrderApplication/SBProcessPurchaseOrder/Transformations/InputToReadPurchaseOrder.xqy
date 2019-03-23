xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://xmlns.oracle.com/ProcessPurchaseOrder/ProcessPurchaseOrderSync/ProcessPurchaseOrderSync";
(:: import schema at "../XSD/ProcessPurchaseOrderSync.xsd" ::)

declare variable $ReadPurchaseOrder as element() (:: schema-element(ns1:process) ::) external;

declare function local:func($ReadPurchaseOrder as element() (:: schema-element(ns1:process) ::)) as element() (:: schema-element(ns1:process) ::) {
    <ns1:process>
        <ns1:input>{fn:data($ReadPurchaseOrder/ns1:input)}</ns1:input>
    </ns1:process>
};

local:func($ReadPurchaseOrder)
